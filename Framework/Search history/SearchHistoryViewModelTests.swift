//
//  SearchHistoryViewModelTests.swift
//  SNLTests
//
//  Created by Håkon Bogen on 14/06/2019,24.
//  Copyright © 2019 Beining & Bogen. All rights reserved.
//

import XCTest
import ReactiveCocoa
import ReactiveSwift
import Result


@testable import Store_norske_leksikon_iOSFramework

class SearchHistoryViewModelTests: XCTestCase {

    let vm = SearchHistoryViewModel()
    let goBack = TestObserver<Void, NoError>()
    let articles = TestObserver<[AutocompleteResult], NoError>()
    let openArticle = TestObserver<AutocompleteResult, NoError>()
    
    var articlesHistory = [AutocompleteResult]()
    
    override func setUp() {
        
        let outputs = vm.outputs()
        outputs.articles.observe(articles.observer)
        outputs.openArticle.observe(openArticle.observer)


        Current.database.addToSearchHistory = { article in
            self.articlesHistory.append(article)
        }
        
        Current.database.fetchSearchHistory = { return self.articlesHistory }
        
    }

    func testShowOldSearchResults() {
        
        let article = AutocompleteResult.template
            |> (\AutocompleteResult.title) .~ "Sau"

        Current.database.addToSearchHistory(article)
        vm.inputs.viewDidLoadObserver.send(value: ())
        articles.assertValue([article])

    }
    
}
