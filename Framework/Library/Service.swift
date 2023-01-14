import Foundation
import ReactiveSwift
import ReactiveCocoa

public struct Service : ServiceType {
    
    public func getArticle(path: Requests.GetArticleRequestable.Path) -> SignalProducer<Requests.GetArticleRequestable.Response, RequestableError> {
         return Requests.GetArticleRequestable.request(serverConfig: self.serverConfig, path: path)
    }

    public func searchArticles(path: Requests.SearchAutocompleteRequestable.Path) -> SignalProducer<Requests.SearchAutocompleteRequestable.Response, RequestableError> {
        return Requests.SearchAutocompleteRequestable.request(serverConfig: self.serverConfig, path: path)
    }
    
    public let serverConfig: ServerConfigType

    public init(serverConfig: ServerConfig = .local) {
        self.serverConfig = serverConfig
    }
}
