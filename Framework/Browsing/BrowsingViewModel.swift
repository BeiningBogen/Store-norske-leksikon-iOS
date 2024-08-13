//
//  BrowsingViewModel.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 03/12/2018,49.
//Copyright © 2018 Beining & Bogen. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result
import WebKit

public final class BrowsingViewModel {
    
    public struct Inputs {
        
        /// Call when the view did load.
        public let (viewDidLoad, viewDidLoadObserver) = Signal<(), NoError>.pipe()
        
        /// Call when the view will disappear
        public let (viewWillDisappear, viewWillDisappearObserver) = Signal<(), NoError>.pipe()
        
        /// Call when a new viewmodel should be configured with an initial URL request
        public let (configure, configureObserver) = Signal<URLRequest, NoError>.pipe()
        
        /// Call when a javascript snippet finds a title in the HTML document
        public let (foundTitle, foundTitleObserver) = Signal<String, NoError>.pipe()
        
        /// Call when when user tapped the search button
        public let (didSearchForArticle, didSearchForArticleObserver) = Signal<AutocompleteResult, NoError>.pipe()
        
        /// Call when webview starts navigation
        public let (didTapSearchButton, didTapSearchButtonObserver) = Signal<Void, NoError>.pipe()
        
        /// Call when more actions button tapped
        public let (didTapMoreActionsButton, didTapMoreActionsButtonObserver) = Signal<Void, NoError>.pipe()
        
        /// Call when more actions button tapped
        public let (didTapVoiceoverButton, didTapVoiceoverButtonObserver) = Signal<Void, NoError>.pipe()
        
        /// Call when share URL in the action sheet was tapped
        public let (didTapShareURLButton, didTapShareURLButtonObserver) = Signal<Void, NoError>.pipe()
        
        /// Call when webview starts navigation
        public let (didStartNavigation, didStartNavigationObserver) = Signal<Void, NoError>.pipe()

        /// Call when webview commits navigation
        public let (didCommitNavigation, didCommitNavigationObserver) = Signal<Void, NoError>.pipe()
        
        /// Call when webview finishes navigation
        public let (didFinishNavigation, didFinishNavigationObserver) = Signal<Void, NoError>.pipe()
        
        /// Call when webview fails navigation
        public let (didFailNavigation, didFailNavigationObserver) = Signal<Void, NoError>.pipe()
        
        /// Call when opening app from url (user tapping a link to snl.no in another app)
        public let (browseAppOpenURL, browseAppOpenURLObserver) = Signal<URL, NoError>.pipe()
        
        /// Call when webview asks for policy for navigation action
        public let (decidePolicyForNavigationAction, decidePolicyForNavigationActionObserver) = Signal<(action: WKNavigationAction, decisionHandler:(WKNavigationActionPolicy) -> Void), NoError>.pipe()
        
        ///
        public let (didTapShowCookiePopupButton, didTapShowCookiePopupObserver) = Signal<Void, NoError>.pipe()
        
        public init() { }
        
    }
    
    public let inputs = Inputs()
    
    public init() { }
    
    
    public typealias Outputs = (
        
        /// Emit the title of the document loaded
        title: Signal<String, NoError>,
        
        /// Emit when a spinner should show
        showLoader: Signal<Bool, NoError>,
        
        /// Emit when webview should strip header and footer
        stripHeaderFooter: Signal<Void, NoError>,
        
        /// Emit when webview should add an initial dom load strip script
        addDOMLoadStripScript: Signal<Void, NoError>,
        
        /// Emit when webview can open a link without pushing a new viewcontroller
        browseOnSamePage: Signal<URLRequest, NoError>,
        
        /// Emit when a new viewcontroller should be pushed with a new request
        browseToNewPage: Signal<URLRequest, NoError>,
        
        /// Emit when webview should ask document for title
        requestForTitle: Signal<Void, NoError>,
        
        /// Emit when the search controller should be shown
        showSearchController: Signal<Void, NoError>,
        
        /// Emit when VoiceOver should start reading the article
        showMoreOptionsController: Signal<Void, NoError>,
        
        /// Emit when VoiceOver should start reading the article
        showShareSheet: Signal<String, NoError>,
        
        /// Emit when VoiceOver should start reading the article
        startVoiceOver: Signal<String, NoError>,
        
        /// Emit when VoiceOver should stop reading the article
        stopVoiceOver: Signal<Void, NoError>,
        
        /// Emit when "More"-button should be showin in right navbar corner
        addMoreButton: Signal<Void, NoError>,
        
        /// Emit when alert for browsing to external link should show
        showExternalLinkAlert: Signal<(Bool, URL?), NoError>,
        
        showCookieConsentButton: Signal<Void, NoError>,
        
        showCookieConsentPopup: Signal<Void, NoError>

    )
    
    enum ArticleLoadingState {
        case started
        case idle
        case finished
    }
    
    public func outputs() -> Outputs {
        
        let showLoader = Signal.merge(
            inputs.viewDidLoad.map { _ in true },
            inputs.didFinishNavigation.map { _ in false },
            inputs.didFailNavigation.map { _ in false }
        )
        
        let addMoreButton = Signal.combineLatest(inputs.configure, inputs.viewDidLoad)
            .filter { $0.0.url != URL.init(string: "https://snl.no")}
            .filter { $0.0.url != URL.init(string: "https://lex.dk")}
            .map { _ in }
        
        /// Only show cookie consent popup on main page of lex
        let showCookieConsentButton = Signal.combineLatest(inputs.configure, inputs.viewDidLoad)
            .filter { $0.0.url == URL.init(string: "https://lex.dk")}
            .map { _ in }
        
        let stripHeaderFooter = inputs.didCommitNavigation
        
        let addDOMLoadStripScript = inputs.didCommitNavigation
        
        let browseOnSamePage = inputs.configure
            .sample(on: inputs.viewDidLoad).map {
                var request = $0
                request.addAppVersionHeader()
                return request
            }
        
        let requestForTitle = inputs.didCommitNavigation
        
        let title = inputs.foundTitle
        
        let articleState = Signal.merge(inputs.viewDidLoad.map { ArticleLoadingState.idle },
                                         inputs.didStartNavigation.map { ArticleLoadingState.started },
                                         inputs.didFinishNavigation.map { ArticleLoadingState.finished })

        let shouldBrowseToNewPage = inputs.decidePolicyForNavigationAction
            .withLatest(from: articleState)
            .filterMap { arg -> URLRequest? in
                
                let (action, decisionHandler) = arg.0
                let state = arg.1
                /// If user taps link, a new VC should load the page
                guard action.navigationType == .linkActivated else {
                    decisionHandler(.allow)
                    return nil
                }
                /// If getting redirect internally in a document, allow the navigation, but don't open a new VC
                if action.navigationType == .other {
                    decisionHandler(.allow)
                    return action.request
                }
                
                if state() == ArticleLoadingState.finished || state() == ArticleLoadingState.started {
                    decisionHandler(.cancel)
                    return action.request
                } else {
                    decisionHandler(.allow)
                    return nil
                }
        }
        
        let showExternalLinkAlert = shouldBrowseToNewPage.map { action in
        
            guard let url = action.url else { return (false, URL(string: ""))}
            
            if url.host != "snl.no" &&
                url.host != "lex.dk" &&
                url.host != "denstoredanske.lex.dk" {
                return (true, url)
            }
            
            return(false, url)
        }
                
        let voiceoverString = inputs.configure
            .sample(on: inputs.didTapVoiceoverButton)
            .filterMap { $0.url?.absoluteString }
            .flatMap(.merge) { url in
                return Current.api.getArticle(.init(path: url + ".json"))
                    .map { $0.xhtml_body.stripOutHtml() }
                    .flatMapError { _ in .empty }
            }
        
        let startVoiceOver: Signal<String, NoError> = Signal.combineLatest(voiceoverString.skipNil(), title)
            .map { "\($1) \($0)" }
        

        let searchURLRequest = inputs.didSearchForArticle.map { URL.init(string: $0.articleURL)!.requestWithAppVersionHeader() }
        
        let browseToNewPage = Signal.merge(shouldBrowseToNewPage,
                                           searchURLRequest,
                                           inputs.browseAppOpenURL.map { $0.requestWithAppVersionHeader() }
            .map {
                var request = $0
                request.addAppVersionHeader()
                return request
        }
        )
        let showMoreOptionsController = inputs.didTapMoreActionsButton

        let showSearchController = inputs.didTapSearchButton
        let showShareSheet = inputs.configure
            .filterMap { $0.url?.absoluteString }.skipNil()
            .sample(on: inputs.didTapShareURLButton)

        let stopVoiceOver = Signal.merge(browseToNewPage.map { _ in },
                                          inputs.viewWillDisappear )
        
        let showCookieConsentPopup = inputs.didTapShowCookiePopupButton
        
        
        return (title : title,
                showLoader : showLoader,
                stripHeaderFooter: stripHeaderFooter,
                addDOMLoadStripScript: addDOMLoadStripScript,
                browseOnSamePage: browseOnSamePage,
                browseToNewPage: browseToNewPage,
                requestForTitle: requestForTitle,
                showSearchController: showSearchController,
                showMoreOptionsController: showMoreOptionsController,
                showShareSheet: showShareSheet,
                startVoiceOver: startVoiceOver,
                stopVoiceOver: stopVoiceOver,
                addMoreButton: addMoreButton,
                showExternalLinkAlert: showExternalLinkAlert,
                showCookieConsentButton: showCookieConsentButton,
                showCookieConsentPopup: showCookieConsentPopup
        )
        
    }
    
}
