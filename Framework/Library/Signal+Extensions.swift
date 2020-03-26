//
//  File.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 16/05/2019,20.
//  Copyright © 2019 Beining & Bogen. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public extension SignalProtocol {
    
    /**
     Transforms the signal into one that observes values on the UI thread.
     
     - returns: A new signal.
     */
    func observeForUI() -> Signal<Value, Error> {
        return self.signal.observe(on: UIScheduler())
    }
}

extension Signal where Error == NoError {
    /// Observe `self` for all values being emitted.
    ///
    /// - parameters:
    ///   - action: A closure to be invoked with values from `self`.
    ///
    /// - returns: A disposable to detach `action` from `self`. `nil` if `self` has
    ///            terminated.
    @discardableResult
    public func observeValuesForUI(_ action: @escaping (Value) -> Void) -> Disposable? {
        return observe(on: UIScheduler()).observe(Observer(value: action))
    }
}
