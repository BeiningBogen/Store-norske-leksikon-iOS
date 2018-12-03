//
//  BrowsingViewModel.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 03/12/2018,49.
//Copyright © 2018 Beining & Bogen. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result

protocol BrowsingViewModelInputs {

}

protocol BrowsingViewModelOutputs {
    var title: Signal<String, NoError> { get }
}

protocol BrowsingViewModelType {
    var inputs: BrowsingViewModelInputs { get }
    var outputs: BrowsingViewModelOutputs { get }
}

class BrowsingViewModel: BrowsingViewModelType, BrowsingViewModelInputs, BrowsingViewModelOutputs {
    init() {
        title = .empty
    }

    let title: Signal<String, NoError>

    var inputs: BrowsingViewModelInputs { return self }
    var outputs: BrowsingViewModelOutputs { return self }
}
