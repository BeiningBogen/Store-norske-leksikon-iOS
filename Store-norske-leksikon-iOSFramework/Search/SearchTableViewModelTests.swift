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

//@testable import ___VARIABLE_productName___Framework
//@testable import ___VARIABLE_productName___Api
@testable import Store_norske_leksikon_iOSFramework

class SearchViewModelTests: XCTestCase {

    let viewModel = SearchTableViewController()
    let goBack = TestObserver<Void, NoError>()

    override func setUp() {
        super.setUp()
//        viewModel.outputs.goBack.observe(goBack.observer)
    }

    override func tearDown() {}

    func testGoBack() {
//        viewModel.inputs.closeTapped()
//        goBack.assertDidEmitValue()
    }
}
