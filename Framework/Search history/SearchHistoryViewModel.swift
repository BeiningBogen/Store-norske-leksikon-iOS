//
//  SearchTableViewModel.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 5/06/2019
//Copyright © 2018 Beining & Bogen. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result

public final class SearchHistoryViewModel {
    
    public struct Inputs {
        
        /// Call when the view did load.
        public let (viewDidLoad, viewDidLoadObserver) = Signal<(), NoError>.pipe()
        
        /// Call when an indexpath is selected, meaning the user has tapped search for a word
        public let (didSelectIndexPath, didSelectIndexPathObserver) = Signal<IndexPath, NoError>.pipe()
        
        /// Call when the regular search is cleared or canceled, refreshing the history
        public let (searchClearedOrCanceled, searchClearedOrCanceledObserver) = Signal<Void, NoError>.pipe()
        
        init() { }
        
    }
    
    public typealias Outputs = (
        
        /// Emit on load, who the verification email is sent to
        title: Signal<String, NoError>,
        
        /// Emit the articles search result to show
        articles: Signal<[Article], NoError>,
        
        /// Emit when the user taps an article in the list
        openArticle: Signal<Article, NoError>
        
    )
    
    public let inputs = Inputs()
    
    public func outputs() -> Outputs {
        
        let title = inputs.viewDidLoad.map { _ in "" }

        let articles = Signal.merge(inputs.viewDidLoad,
                                    inputs.searchClearedOrCanceled)
                .map { _ -> [Article] in
                    let history = Current.database.fetchSearchHistory()
                    return history
                    
        }
        
        let openArticle = inputs.didSelectIndexPath
            .withLatest(from: articles).map { $0.1[$0.0.row]}

        return (title : title,
                articles: articles,
                openArticle: openArticle
        )
    }
}
