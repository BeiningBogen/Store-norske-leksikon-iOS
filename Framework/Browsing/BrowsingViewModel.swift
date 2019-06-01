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
        
        /// Call when a new viewmodel should be configured with an initial URL request
        public let (configure, configureObserver) = Signal<URLRequest, NoError>.pipe()
        
        /// Call when a javascript snippet finds a title in the HTML document
        public let (foundTitle, foundTitleObserver) = Signal<String, NoError>.pipe()
        
        /// Call when when user tapped the search button
        public let (didSearchForArticle, didSearchForArticleObserver) = Signal<Article, NoError>.pipe()
        
        /// Call when webview starts navigation
        public let (didTapSearchButton, didTapSearchButtonObserver) = Signal<Void, NoError>.pipe()
        
        /// Call when webview starts navigation
        public let (didStartNavigation, didStartNavigationObserver) = Signal<Void, NoError>.pipe()

        /// Call when webview commits navigation
        public let (didCommitNavigation, didCommitNavigationObserver) = Signal<Void, NoError>.pipe()
        
        /// Call when webview finishes navigation
        public let (didFinishNavigation, didFinishNavigationObserver) = Signal<Void, NoError>.pipe()
        
        /// Call when webview fails navigation
        public let (didFailNavigation, didFailNavigationObserver) = Signal<Void, NoError>.pipe()
        
        /// Call when webview asks for policy for navigation action
        public let (decidePolicyForNavigationAction, decidePolicyForNavigationActionObserver) = Signal<(action: WKNavigationAction, decisionHandler:(WKNavigationActionPolicy) -> Void), NoError>.pipe()
        
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
        showSearchController: Signal<Void, NoError>
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

        let stripHeaderFooter = inputs
            .didCommitNavigation.delay(0.1, on: QueueScheduler.main)
        
        let addDOMLoadStripScript = inputs.didCommitNavigation

        let browseOnSamePage = inputs.configure
            .sample(on: inputs.viewDidLoad)
        
        let requestForTitle = inputs.didCommitNavigation
        
        let title = inputs.foundTitle
        
        let articleState = Signal.merge(inputs.viewDidLoad.map { ArticleLoadingState.idle },
                                         inputs.didStartNavigation.map { ArticleLoadingState.started},
                                         inputs.didFinishNavigation.map { ArticleLoadingState.finished})

        let shouldBrowseToNewPage = inputs.decidePolicyForNavigationAction
            .withLatest(from: articleState)
            .filterMap { arg -> URLRequest? in
                
                let (action, decisionHandler) = arg.0
                let state = arg.1

                guard action.navigationType == .linkActivated || action.navigationType == .other else {
                    decisionHandler(.allow)
                    return nil
                }
                
                if state == ArticleLoadingState.finished || state == .started {
                    decisionHandler(.cancel)
                    return action.request
                } else {
                    decisionHandler(.allow)
                    return nil
                }
        }
        let searchURLRequest = inputs.didSearchForArticle.map { URLRequest.init(url: URL.init(string: $0.articleURL)!) }
        
        let browseToNewPage = Signal.merge(shouldBrowseToNewPage,
                                           searchURLRequest)

        let showSearchController = inputs.didTapSearchButton
        
        return (title : title,
                showLoader : showLoader,
                stripHeaderFooter: stripHeaderFooter,
                addDOMLoadStripScript: addDOMLoadStripScript,
                browseOnSamePage: browseOnSamePage,
                browseToNewPage: browseToNewPage,
                requestForTitle: requestForTitle,
                showSearchController: showSearchController
            
        )
        
    }
    
}
