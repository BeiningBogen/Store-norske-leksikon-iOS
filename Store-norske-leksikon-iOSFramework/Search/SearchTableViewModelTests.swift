//
//  SearchTableViewModelTests.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 11/12/2018,50.
//Copyright © 2018 Beining & Bogen. All rights reserved.
//

import XCTest
import ReactiveCocoa
import ReactiveSwift
import Result

@testable import Store_norske_leksikon_iOSFramework
@testable import Store_norske_leksikon_iOSApi


extension XCTestCase {
    
    func asyncMockResponsesTest(mockService: MockService, expectationTimeout: TimeInterval = 10, expectationDescription: String = #function, body: (XCTestExpectation) -> Void) {
        
        let exp = expectation(description: expectationDescription)
        let environment = Environment.init(service: mockService, apiDelayInterval: DispatchTimeInterval.milliseconds(3000))
        AppEnvironment.pushEnvironment(environment: environment)

        body(exp)

        AppEnvironment.popEnvironment()
        waitForExpectations(timeout: expectationTimeout, handler: nil)
        
    }
    
}

class SearchViewModelTests: XCTestCase {

    let vm = SearchTableViewModel()
    let goBack = TestObserver<Void, NoError>()
    let articles = TestObserver<[Article], NoError>()

    override func setUp() {
        super.setUp()
        vm.outputs.articles.observe(articles.observer)
        
    }

    func testShowArticles() {
        
        let article = Article.template
        
        let mockService = MockService.template
            |> (\MockService.searchArticlesResponse) .~ [article]
        
        asyncMockResponsesTest(mockService: mockService) { (exp) in
            
            vm.inputs.viewDidLoad()
            vm.inputs.searchTextChanged(text: "Sau")
            articles.assertDidEmitValue()
            
            exp.fulfill()
            
        }
        
    }
    
}
