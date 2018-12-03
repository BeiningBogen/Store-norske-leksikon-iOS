import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
public struct BasicHTTPAuth {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password

    }

    public var authorizationHeader: [String: String] {
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength76Characters)
        let header = ["Authorization": "Basic \(base64Credentials)"]

        return header
    }
}

public protocol ServerConfigType {
    var baseURL: URL { get }
    var basicHTTPAuth: BasicHTTPAuth? { get }
}

public struct ServerConfig: ServerConfigType {
    public private(set) var basicHTTPAuth: BasicHTTPAuth?
    public let baseURL: URL

    public init(baseURL: URL,basicHTTPAuth: BasicHTTPAuth?) {

        self.baseURL = baseURL
        self.basicHTTPAuth = basicHTTPAuth
    }

    public static let local : ServerConfig = ServerConfig.init(baseURL: URL(string: "http://localhost:8080")!, basicHTTPAuth: nil)
    public static let staging : ServerConfig = ServerConfig.init(baseURL: URL(string: "http://localhost:8080")!, basicHTTPAuth: nil)

}

public protocol PathComponentsProvider {
    associatedtype Query: Encodable
    var pathComponents: (path: [String], query: Query?) { get }
}

extension Never: Encodable {
    public func encode(to encoder: Encoder) throws {}
}

public enum RequestableParameterEncoding {
    case query
    case json
    case custom(contentType: String, transform: (Data) throws -> Data?)

    var contentType: String {
        switch self {
        case .query:
            return "application/x-www-form-urlencoded"
        case .json:
            return "application/json"
        case .custom(let type, _):
            return type
        }
    }
}

public enum RequestableError: Error, CustomDebugStringConvertible {
    case invalidUrl(components: URLComponents)
    case encoding(error: EncodingError)
    case decoding(error: DecodingError, data: Data)
    case statusCode(code: Int, response: HTTPURLResponse, data: Data)
    case underlying(error: Error)
    case logicError(description: String)
    case shopError(error: Error)

    public var debugDescription: String {
        switch self {
        case .invalidUrl(components: let components):
            return "Invalid URL: \(components.description)"
        case .underlying(error: let error):
            return String(describing: error)
        case .encoding(error: let error):
            return String(describing: error)
        case .decoding(error: let error, data: let data):
            return [String(describing: error), String(data: data, encoding: .utf8).map { "JSON: \($0)" }]
                .compactMap { $0 }
                .joined(separator: ", ")
        case .statusCode(code: let code, response: let response, data: let data):
            return ["Code: \(code)", response.description, String(data: data, encoding: .utf8).map { "JSON: \($0)" }]
                .compactMap { $0 }
                .joined(separator: ", ")
        case .logicError(let description):
            return description
        case .shopError(error: let error):
            return String(describing: error)
        }
    }
}

public protocol Requestable {
    associatedtype Parameter: Encodable
    associatedtype Path: PathComponentsProvider
    associatedtype Response

    static var method: HTTPMethod { get }
    static var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy { get }
    static var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy { get }
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
    static var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy { get }
    static var parameterEncoding: RequestableParameterEncoding { get }
    static var sessionConfig: URLSessionConfiguration { get }
}

extension Requestable {
    public static var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        return .deferredToDate
    }

    public static var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy {
        return .deferredToData
    }

    public static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .deferredToDate
    }

    public static var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        return .deferredToData
    }

    public static var parameterEncoding: RequestableParameterEncoding {
        return .json
    }

    public static var mainHeaders: [String: String] {
        return [
            "Accept": RequestableParameterEncoding.json.contentType,
            "Content-Type": parameterEncoding.contentType
        ]
    }

    public static var sessionConfig: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 30
        config.timeoutIntervalForRequest = 30
        return config
    }
}

extension Requestable {
    internal static func requestData(serverConfig: ServerConfigType, path: Path, parameters: Parameter?, sessionConfig: URLSessionConfiguration? = nil) -> SignalProducer<Data, RequestableError> {

        return SignalProducer<Data, RequestableError> { observer, lifetime in

            let auth: [String: String]? = serverConfig.basicHTTPAuth?.authorizationHeader

            var urlComponents = URLComponents(string: serverConfig.baseURL.absoluteString)!


            do {
                if let baseUrl = urlComponents.url {
                    let encoder = JSONEncoder()
                    encoder.dataEncodingStrategy = dataEncodingStrategy
                    encoder.dateEncodingStrategy = dateEncodingStrategy
                    if let query = path.pathComponents.query {

                        let decoded = try JSONSerialization.jsonObject(with: encoder.encode(query), options: [])

                        guard let dictionary = decoded as? [String: Any] else {
                            throw EncodingError.invalidValue(decoded, .init(codingPath: [], debugDescription: "Expected to decode Dictionary<String, _> but found a Dictionary<_, _> instead"))
                        }
                        urlComponents.queryItems = dictionary.map { URLQueryItem(name: $0, value: String(describing: $1)) }
                    }

                    let url = path.pathComponents.path.reduce(baseUrl, { $0.appendingPathComponent($1) })
                    var request = URLRequest(url: url)
                    request.httpMethod = method.rawValue
                    request.httpBody = try parameters.map(encoder.encode)
                    mainHeaders
                        .merging(auth ?? [:], uniquingKeysWith: { $1 })
                        .forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
                    let task = URLSession(configuration: sessionConfig ?? self.sessionConfig).dataTask(with: request) { data, response, error in
                        debugPrintYAML(request: request, response: response, received: data, error: error.map(RequestableError.underlying))
                        switch (data, response, error) {
                        case (_, _, let error?):
                            observer.send(error: .underlying(error: error))
                        case (let data?, let response as HTTPURLResponse, _):
                            if 200...299 ~= response.statusCode {
                                observer.send(value: data)
                                observer.sendCompleted()
                            } else {
                                observer.send(error: .statusCode(code: response.statusCode, response: response, data: data))
                            }
                        case (let data?, _, _):
                            observer.send(value: data)
                            observer.sendCompleted()
                        default:
                            observer.sendCompleted()
                        }
                    }
                    lifetime.observeEnded(task.cancel)
                    task.resume()
                } else {
                    observer.send(error: .invalidUrl(components: urlComponents))
                }
            } catch let error as EncodingError {
                observer.send(error: .encoding(error: error))
            } catch {
                observer.send(error: .underlying(error: error))
            }
        }
    }
}

extension Requestable {
    static func headerTransform(_ header: [AnyHashable: Any]?, indent: Int) -> String {
        return (header ?? [:]).map { "\(Array(repeating: "    ", count: indent).joined())\($0): \($1)" }.joined(separator: "\n")
    }

    static func dataTransform(_ data: Data?) -> String {
        return data.flatMap { String(data: $0, encoding: .utf8) } ?? "null"
    }

    static func debugYAML(request: URLRequest?) -> String? {
        guard let request = request,
            let method = request.httpMethod,
            let url = request.url
            else { return nil }
        return """
        Request:
        Method: \(method)
        URL: \(url)
        Header:
        \(headerTransform(request.allHTTPHeaderFields, indent: 2))
        Body: \(dataTransform(request.httpBody))
        """
    }

    static func debugCURL(request: URLRequest?) -> String {
        guard let request = request,
            let httpMethod = request.httpMethod,
            let url = request.url,
            let allHTTPHeaderFields = request.allHTTPHeaderFields
            else { return "" }
        let bodyComponents: [String]
        if let data = request.httpBody.flatMap({ String(data: $0, encoding: .utf8) }) {
            switch parameterEncoding {
            case .query:
                bodyComponents = data.split(separator: "&").map { "-F \($0)" }
            default:
                bodyComponents = ["-d", "'\(data)'"]
            }
        } else {
            bodyComponents = []
        }
        let method = "-X \(httpMethod)"
        let headers = allHTTPHeaderFields.map { "-H '\($0.key): \($0.value)'" }
        return ((["curl", method] + headers + bodyComponents + [url.absoluteString]) as [String])
            .joined(separator: " ")
    }

    static func debugYAML(response: URLResponse?, data: Data?) -> String? {
        guard let response = response as? HTTPURLResponse else { return nil }
        return """
        Response:
        Code: \(response.statusCode)
        Header:
        \(headerTransform(response.allHeaderFields, indent: 2))
        Body: \(dataTransform(data))
        """
    }

    static func debugYAML(responseError error: RequestableError?) -> String? {
        guard let error = error else { return nil }
        return """
        Response:
        Error: \(error.debugDescription)
        """
    }

    static func debugPrintYAML(request: URLRequest?, response: URLResponse?, received: Data?, error: RequestableError? = nil) {
        let responseYaml = debugYAML(responseError: error) ?? debugYAML(response: response, data: received)
        let yaml = [debugYAML(request: request), responseYaml]
            .compactMap { $0 }
            .joined(separator: "\n")
        let info = """
        #######################
        ##### Requestable #####
        #######################
        # cURL format:
        # \(debugCURL(request: request))
        #######################
        # YAML format:
        \(yaml)
        #######################
        """
        print("\n\(info)\n")
    }
}

extension Requestable where Response: Decodable {
    internal static func decode(data: Data) -> Result<Response, RequestableError> {
        let decoder = JSONDecoder()
        do {
            decoder.dataDecodingStrategy = dataDecodingStrategy
            decoder.dateDecodingStrategy = dateDecodingStrategy
            return .success(try decoder.decode(Response.self, from: data))
        } catch {
            return .failure(.decoding(error: error as! DecodingError, data: data))
        }
    }
}

extension Requestable where Response == Data {
    public static func request(serverConfig: ServerConfigType, path: Path, parameters: Parameter, sessionConfig: URLSessionConfiguration? = nil) -> SignalProducer<Response, RequestableError> {
        return requestData(serverConfig: serverConfig, path: path, parameters: parameters, sessionConfig: sessionConfig)
    }
}

extension Requestable where Response == Data, Parameter == Never {
    public static func request(serverConfig: ServerConfigType, path: Path, sessionConfig: URLSessionConfiguration? = nil) -> SignalProducer<Response, RequestableError> {
        return requestData(serverConfig: serverConfig, path: path, parameters: nil, sessionConfig: sessionConfig)
    }
}

extension Requestable where Response: Decodable {
    public static func request(serverConfig: ServerConfigType, path: Path, parameters: Parameter, sessionConfig: URLSessionConfiguration? = nil) -> SignalProducer<Response, RequestableError> {
        return requestData(serverConfig: serverConfig, path: path, parameters: parameters, sessionConfig: sessionConfig)
            .attemptMap(decode(data:))
    }
}


extension Requestable where Response: Decodable, Parameter == Never {
    public static func request(service: ServiceType, path: Path, sessionConfig: URLSessionConfiguration? = nil) -> SignalProducer<Response, RequestableError> {

        return requestData(serverConfig: service.serverConfig, path: path, parameters: nil, sessionConfig: sessionConfig)
            .attemptMap(decode(data:))
    }

    public static func request(serverConfig: ServerConfigType, path: Path, sessionConfig: URLSessionConfiguration? = nil) -> SignalProducer<Response, RequestableError> {

        return requestData(serverConfig: serverConfig, path: path, parameters: nil, sessionConfig: sessionConfig)
            .attemptMap(decode(data:))
    }
}
