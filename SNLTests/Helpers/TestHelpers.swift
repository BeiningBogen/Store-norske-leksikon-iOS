//
//  TestHelpers.swift
//  SNLTests
//
//  Created by Håkon Bogen on 20/05/2019,21.
//  Copyright © 2019 Beining & Bogen. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result


let APITestDelay: TimeInterval = 1

extension TimeInterval {

    var requestCompletionDelay: TimeInterval {
        return self + 0.5
    }
    
    var assertionDelay: TimeInterval {
        return self + 1
    }
        
    var expectationTimeout: TimeInterval {
        return self + 2
    }
}
    
extension SignalProducer {
    

    public func delayForTest() -> SignalProducer<Value, Error > {
        return self.delay(APITestDelay.requestCompletionDelay, on: QueueScheduler())
    }
    
}

//public func delay(_ interval: TimeInterval, on scheduler: DateScheduler) -> SignalProducer<Value, Error> {
//    return core.flatMapEvent(Signal.Event.delay(interval, on: scheduler))
//}
//

