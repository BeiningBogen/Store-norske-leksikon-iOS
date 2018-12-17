//
//  SearchTableViewCellViewModelTests.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 17/12/2018,51.
//  Copyright © 2018 Beining & Bogen. All rights reserved.
//

import XCTest
import ReactiveCocoa
import ReactiveSwift
import Result

@testable import Store_norske_leksikon_iOSFramework
@testable import Store_norske_leksikon_iOSApi

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
        
        let article = Article.template
            |> (\Article.headword) .~ "Test article name"
            |> (\Article.firstTwoSentences) .~ "Lorem ipsum and stuff like that"
        
        vm.inputs.configureWith(article: article)
        
        title.assertValues([article.headword])
        excerpt.assertValues([article.firstTwoSentences])

    }
}
