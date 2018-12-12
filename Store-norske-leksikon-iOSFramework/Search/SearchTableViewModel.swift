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

public protocol SearchTableViewModelInputs {
    func viewDidLoad()
    func configure(texts: [String])
}

public protocol SearchTableViewModelOutputs {
    var cells: Signal<[String], NoError> { get }
}

public protocol SearchTableViewModelType {
    var inputs: SearchTableViewModelInputs { get }
    var outputs: SearchTableViewModelOutputs { get }
}

public class SearchTableViewModel: SearchTableViewModelType, SearchTableViewModelInputs, SearchTableViewModelOutputs {
    init() {
        cells = configureWithTextProperty.signal.skipNil()
    }

    let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        viewDidLoadProperty.value = ()
    }

    let configureWithTextProperty = MutableProperty<[String]?>(nil)
    public func configure(texts: [String]) {
        configureWithTextProperty.value = texts
    }

    public let cells: Signal<[String], NoError>

    public var inputs: SearchTableViewModelInputs { return self }
    public var outputs: SearchTableViewModelOutputs { return self }
}
