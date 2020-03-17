import Foundation
import ReactiveSwift
import Chimney

private func searchArticles(path: Requests.SearchArticlesRequestable.Path) -> SignalProducer<Requests.SearchArticlesRequestable.Response, RequestableError> {
    return SignalProducer<Requests.SearchArticlesRequestable.Response, RequestableError> { observer, _ in
        Requests.SearchArticlesRequestable.request(path: path) { result in
            switch result {
                case .success(let response):
                    observer.send(value: response)
                case .failure(let error):
                    observer.send(error: error)
            }
        }
    }
}

private func getArticle(path: Requests.GetArticleRequestable.Path) -> SignalProducer<Requests.GetArticleRequestable.Response, RequestableError> {
    return SignalProducer<Requests.GetArticleRequestable.Response, RequestableError> { observer, _ in
        Requests.GetArticleRequestable.request(path: path) { result in
            switch result {
                case .success(let response):
                    observer.send(value: response)
                case .failure(let error):
                    observer.send(error: error)
            }
        }
    }
}

struct Environment {
    
    public var api = Api()
    public var database = Database()
    init() {
        Chimney.environment = Chimney.Environment(configuration: Configuration.init(basicHTTPAuth: nil, baseURL: URL.init(string: "https://snl.no")!))
    }

}

struct Api {
    
    var searchArticles = searchArticles(path:)
    var getArticle = getArticle(path:)
}


var Current = Environment()

public struct RequestableAlertModel {
    let title: String
    let message: String
}
