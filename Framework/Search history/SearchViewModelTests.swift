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

public func after(_ duration: Double, closure: @escaping () -> Void) {
    
    let delayTime = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        
        closure()
        
    }
    
}

extension XCTestCase {

    func asyncTest(expectationDescription : String = #function, assertionClosure: @escaping () -> Void) {
        
        let exp = expectation(description: expectationDescription)

        after(APITestDelay.assertionDelay) {
            assertionClosure()
            exp.fulfill()
        }
        
        waitForExpectations(timeout: APITestDelay.expectationTimeout, handler: nil)
    }
}

class SearchViewModelTests: XCTestCase {

    let vm = SearchViewModel()
    let goBack = TestObserver<Void, NoError>()
    let articles = TestObserver<[AutocompleteResult], NoError>()
    let showLoader = TestObserver<Bool, NoError>()
    let showError = TestObserver<RequestableAlertModel, NoError>()

    override func setUp() {
        super.setUp()
        
        let outputs = vm.outputs()
        
        outputs.articles.observe(articles.observer)
        
    }

    func testShowArticles() {
        
        let article = AutocompleteResult.template

        Current.api.searchArticles =  { _ in SignalProducer.init(value: [article]).delayForTest() }

        vm.inputs.viewDidLoadObserver.send(value: ())
        vm.inputs.searchTextChangedObserver.send(value: "sau")
        asyncTest {
            self.articles.assertDidEmitValue()
        }
    }
    
    func testDoNotShowArticleOnFail() {
        
        let exp = expectation(description: "test")
        
        vm.inputs.viewDidLoadObserver.send(value: ())
        vm.inputs.searchTextChangedObserver.send(value: "sau")
        
        Current.api.searchArticles =  { _ in SignalProducer.init(error:RequestableError.logicError(description: "testfail")) }
        
        after(APITestDelay) {
            
            self.articles.assertDidNotEmitValue()
            
            exp.fulfill()
            
        }
        waitForExpectations(timeout: APITestDelay.expectationTimeout, handler: nil)
    }
    
}
