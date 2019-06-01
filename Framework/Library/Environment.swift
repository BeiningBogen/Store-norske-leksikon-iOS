import Foundation
import ReactiveSwift



private var serverConfig: ServerConfigType = ServerConfig.local

public func searchArticles(path: Requests.SearchArticlesRequestable.Path) -> SignalProducer<Requests.SearchArticlesRequestable.Response, RequestableError> {
    return Requests.SearchArticlesRequestable.request(serverConfig: serverConfig, path: path)
}

public struct Environment {
    
    public var api = Api()

}

public struct Api {
    
    public let basicAuth: BasicHTTPAuth?
    
    public init() { self.basicAuth = nil }
    
    public init(serverConfig newServerConfig: ServerConfigType) {
        serverConfig = newServerConfig
        self.basicAuth = newServerConfig.basicHTTPAuth
    }
    
    var searchArticles = searchArticles(path:)
    
}


public var Current = Environment()
