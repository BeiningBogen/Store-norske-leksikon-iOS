import Foundation
import ReactiveCocoa
import ReactiveSwift

//public class LastPerformedRequest {
//    public static var request: Any?
//}


public struct MockService : ServiceType {
    
    public func searchArticles(path: Requests.SearchArticlesRequestable.Path) -> SignalProducer<Requests.SearchArticlesRequestable.Response, RequestableError> {
        if let response = searchArticlesResponse {
            return SignalProducer.init(value: response)
        }
        return .empty
    }
    
    public func getArticle(path: Requests.GetArticleRequestable.Path) -> SignalProducer<Requests.GetArticleRequestable.Response, RequestableError> {
        return .empty
    }

    public static var lastPerformedRequest: Any?

    public private(set) var searchArticlesResponse: Requests.SearchArticlesRequestable.Response?
    public private(set) var searchArticlesError: RequestableError?

    public var serverConfig: ServerConfigType

    public init(serverConfig: ServerConfigType, searchArticlesResponse: Requests.SearchArticlesRequestable.Response? = nil, searchArticlesError: RequestableError? = nil) {

        self.searchArticlesResponse = searchArticlesResponse
        self.searchArticlesError = searchArticlesError
        self.serverConfig = serverConfig

    }

}
