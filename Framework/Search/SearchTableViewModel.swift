//
//  SearchTableViewModel.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 11/12/2018,50.
//Copyright © 2018 Beining & Bogen. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result

public final class SearchViewModel {
    
    public struct Inputs {
        
        /// Call when the view did load.
        public let (viewDidLoad, viewDidLoadObserver) = Signal<(), NoError>.pipe()
        
        /// Call when the view did load.
        public let (searchTextChanged, searchTextChangedObserver) = Signal<String, NoError>.pipe()
        
        /// Call when an indexpath is selected
        public let (didSelectIndexPath, didSelectIndexPathObserver) = Signal<IndexPath, NoError>.pipe()
        
        init() { }
        
    }
    
    public typealias Outputs = (
        
        /// Emit on load, who the verification email is sent to
        title: Signal<String, NoError>,
        
        /// Emit the articles search result to show
        articles: Signal<[Article], NoError>,
        
        /// Emit when the user taps an article in the list
        openArticle: Signal<Article, NoError>,
        
        /// Emit when the spinner should show
        showLoader: Signal<Bool, NoError>,
        
        /// Emit when the spinner should show
        showError: Signal<RequestableAlertModel, NoError>
    )
    
    public let inputs = Inputs()
    
    public func outputs() -> Outputs {
        
        let title = inputs.viewDidLoad.map { _ in "" }

        let searchArticlesRequest = inputs
            .searchTextChanged
            .debounce(0.35, on: QueueScheduler())
            .flatMap(.latest) { art -> SignalProducer<([Article]?, RequestableError?), NoError> in
                Current.api.searchArticles(.init(searchWord: art))
                    .map { ($0, nil)}
                    .flatMapError { SignalProducer.init(value:(nil, $0))}
            }

        let articles = searchArticlesRequest
            .filterMap { $0.0 }
        
        let openArticle = inputs.didSelectIndexPath
            .withLatest(from: articles).map { $0.1[$0.0.row]}

        // Not used yet
        let showLoader = inputs
            .viewDidLoad.map { _ in true }
        
        let showError = searchArticlesRequest
            .filterMap { $0.1 }
            .map { _ in RequestableAlertModel(title: "Kunne ikke søke", message: "Sjekk tilkoblingen din og prøv på nytt") }

        return (title : title,
                articles: articles,
                openArticle: openArticle,
                showLoader: showLoader,
                showError: showError
        )
    }
}
