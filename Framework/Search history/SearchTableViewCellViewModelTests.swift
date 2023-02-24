//
//  SearchTableViewCellViewModelTests.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 17/12/2018,51.
//  Copyright © 2018 Beining & Bogen. All rights reserved.
//

import XCTest
//import ReactiveCocoa
import ReactiveSwift
import Result

@testable import Store_norske_leksikon_iOSFramework

class SearchTableViewCellViewModelTests: XCTestCase {

    let vm = SearchTableViewCellViewModel()

    let title = TestObserver<String, NoError>()
    let excerpt = TestObserver<String, NoError>()

    override func setUp() {
        super.setUp()
        vm.outputs.title.observe(title.observer)
        vm.outputs.excerpt.observe(excerpt.observer)
        
    }

    func testShowAttributes() {
        let startExcerpt = "Lorem ipsum and stuff like that"
        let endExcerpt = "\(startExcerpt)..."
        
        let article = AutocompleteResult.template
        |> (\AutocompleteResult.title) .~ "Test article name"
        |> (\AutocompleteResult.excerpt) .~ startExcerpt
        
        vm.inputs.configureWith(article: article)
        
        title.assertValues([article.title])
        excerpt.assertValues([endExcerpt])

    }
}
