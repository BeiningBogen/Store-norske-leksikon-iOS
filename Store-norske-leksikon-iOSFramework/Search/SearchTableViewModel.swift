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
import Store_norske_leksikon_iOSApi

public protocol SearchTableViewModelInputs {
    func viewDidLoad()
    func configure(texts: [String])
    func searchTextChanged(text: String)
}

public protocol SearchTableViewModelOutputs {
    var cells: Signal<[String], NoError> { get }
    var articles: Signal<[Article], NoError> { get }
    
}

public protocol SearchTableViewModelType {
    var inputs: SearchTableViewModelInputs { get }
    var outputs: SearchTableViewModelOutputs { get }
}

public class SearchTableViewModel: SearchTableViewModelType, SearchTableViewModelInputs, SearchTableViewModelOutputs {

    init() {
        
        cells = configureWithTextProperty.signal.skipNil()
        
        let art = searchTextChangedProperty.signal.skipNil()
            .flatMap(.latest) { art -> SignalProducer<([Article]?, RequestableError?), NoError> in
            return AppEnvironment.current.service.searchArticles(path: Requests.SearchArticlesRequestable.Path.init(searchWord: art))
                .map { result -> ([Article], RequestableError?) in
                    return (result, nil)
                }.flatMapError { error in
                    SignalProducer.init(value: (nil, error))
                }
        }
        self.articles = art.map { $0.0 }.skipNil()
    }
    

    let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        viewDidLoadProperty.value = ()
    }

    let configureWithTextProperty = MutableProperty<[String]?>(nil)
    public func configure(texts: [String]) {
        configureWithTextProperty.value = texts
    }

    let searchTextChangedProperty = MutableProperty<String?>(nil)
    public func searchTextChanged(text: String) {
        searchTextChangedProperty.value = text
    }
    
    public let cells: Signal<[String], NoError>
    public let articles: Signal<[Article], NoError>

    public var inputs: SearchTableViewModelInputs { return self }
    public var outputs: SearchTableViewModelOutputs { return self }
}
