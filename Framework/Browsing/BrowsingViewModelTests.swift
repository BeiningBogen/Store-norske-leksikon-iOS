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

    let vm = BrowsingViewModel()

    let title = TestObserver<String, NoError>()
    let browseToNewPage = TestObserver<URLRequest, NoError>()
    let browseOnSamePage = TestObserver<URLRequest, NoError>()
    let requestForTitle = TestObserver<Void, NoError>()
    let showLoader = TestObserver<Bool, NoError>()
    let stripHeaderFooter = TestObserver<Void, NoError>()
    let addDomLoadStripScript = TestObserver<Void, NoError>()

    override func setUp() {
        super.setUp()
        
        let outputs = vm.outputs()

        outputs.title.observe(title.observer)
        outputs.showLoader.observe(showLoader.observer)
        outputs.stripHeaderFooter.observe(stripHeaderFooter.observer)
        
//            /// Emit when webview should add an initial dom load strip script
//            addDOMLoadStripScript: Signal<Void, NoError>,
//
//            /// Emit when webview can open a link without pushing a new viewcontroller
//            browseOnSamePage: Signal<URLRequest, NoError>,
//
//            /// Emit when a new viewcontroller should be pushed with a new request
//            browseToNewPage: Signal<URLRequest, NoError>,
//
//            /// Emit when webview should ask document for title
//            requestForTitle: Signal<Void, NoError>,
//
//            /// Emit when the search controller should be shown
//            showSearchController: Signal<Void, NoError>
        
    }

    func testShowFrontPageOnRootVC() {
        
        vm.inputs.viewDidLoadObserver.send(value: ())
        vm.inputs.configureObserver.send(value: URLRequest.init(url: URL.init(string: "snl.no")!))
        showLoader.assertDidEmitValue()

    }
    
    func testShowLoaderOnInit() {
        
        
    }
    
    
}
