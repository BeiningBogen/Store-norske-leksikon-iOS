//
// BrowsingViewModelTests.swift
// Store-norske-leksikon-iOS
//
// Created by Håkon Bogen on 03/12/2018,49.
//Copyright © 2018 Beining & Bogen. All rights reserved.
//

import XCTest
import ReactiveCocoa
import ReactiveSwift
import Result

@testable import Store_norske_leksikon_iOSFramework

class BrowsingViewModelTests: XCTestCase {

    let viewModel = BrowsingViewModel()

    let test = TestObserver<String, NoError>()

    override func setUp() {
        super.setUp()

//        viewModel.outputs.test.observe(test.observer)
        
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() {

    }
}
