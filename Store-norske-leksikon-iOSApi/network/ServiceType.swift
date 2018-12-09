import Foundation
import ReactiveCocoa
import ReactiveSwift

public protocol ServiceType {

    var serverConfig: ServerConfigType { get }

    func getArticle(path: Requests.GetArticleRequestable.Path) -> SignalProducer<Requests.GetArticleRequestable.Response, RequestableError>

}
