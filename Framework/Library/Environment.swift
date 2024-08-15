import Foundation
import ReactiveSwift



private var serverConfig: ServerConfigType = ServerConfig.local

public func searchArticles(path: Requests.SearchAutocompleteRequestable.Path) -> SignalProducer<Requests.SearchAutocompleteRequestable.Response, RequestableError> {
    return Requests.SearchAutocompleteRequestable.request(serverConfig: serverConfig, path: path)
}

public func getArticle(path: Requests.GetArticleRequestable.Path) -> SignalProducer<Requests.GetArticleRequestable.Response, RequestableError> {
    return Requests.GetArticleRequestable.request(serverConfig: serverConfig, path: path)
}

public struct Environment {
    
    
    public var api = Api()
    public var database = Database()
    public var appSettings = AppSettings()

}

public struct AppSettings {
    
    public init(speechSynthesizedLanguage: String = "nb-NO", searchBaseURL: String = "https://snl.no", domTitleToBeStripped: String = " – Store norske leksikon ", mobileCookieConsentValues: MobileCookieConsentValues? = nil) {
        self.speechSynthesizedLanguage = speechSynthesizedLanguage
        self.searchBaseURL = searchBaseURL
        self.domTitleToBeStripped = domTitleToBeStripped
    }
    
    
    public var speechSynthesizedLanguage: String
    
    public var domTitleToBeStripped: String
    
    public var searchBaseURL: String
    
    public var mobileCookieConsentValues: MobileCookieConsentValues?
    
}

public struct Api {
    
    public let basicAuth: BasicHTTPAuth?
    
    public init() { self.basicAuth = nil }
    
    public init(serverConfig newServerConfig: ServerConfigType) {
        serverConfig = newServerConfig
        self.basicAuth = newServerConfig.basicHTTPAuth
    }
    
    var searchArticles = searchArticles(path:)
    var getArticle = getArticle(path:)
}


public var Current = Environment()
