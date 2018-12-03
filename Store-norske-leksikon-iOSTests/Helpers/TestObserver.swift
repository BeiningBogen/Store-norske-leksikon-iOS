// Copyright 2018 Kickstarter, PBC.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import XCTest
import ReactiveSwift

/**
 A `TestObserver` is a wrapper around an `Observer` that saves all events to an internal array so that
 assertions can be made on a signal's behavior. To use, just create an instance of `TestObserver` that
 matches the type of signal/producer you are testing, and observer/start your signal by feeding it the
 wrapped observer. For example,

 ```
 let test = TestObserver<Int, NoError>()
 mySignal.observer(test.observer)

 // ... later ...

 test.assertValues([1, 2, 3])
 ```
 */
internal final class TestObserver <Value, Error: Swift.Error> {

    internal private(set) var events: [Signal<Value, Error>.Event] = []
    internal private(set) var observer: Signal<Value, Error>.Observer!

    internal init() {
        self.observer = Signal<Value, Error>.Observer(action)
    }

    private func action(_ event: Signal<Value, Error>.Event) {
        self.events.append(event)
    }

    /// Get all of the next values emitted by the signal.
    internal var values: [Value] {
        return self.events
            .filter { $0.value != nil }
            .map { $0.value! }
    }

    /// Get the last value emitted by the signal.
    internal var lastValue: Value? {
        return self.values.last
    }

    /// `true` if at least one `.Next` value has been emitted.
    internal var didEmitValue: Bool {
        return self.values.count > 0
    }

    /// `true` if a `.Completed` event has been emitted.
    internal var didComplete: Bool {
        return self.events.filter { $0.isCompleted }.count > 0
    }

    internal func assertDidComplete(_ message: String = "Should have completed.",
                                    file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(self.didComplete, message, file: file, line: line)
    }

    internal func assertDidNotComplete(_ message: String = "Should not have completed",
                                       file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(self.didComplete, message, file: file, line: line)
    }

    internal func assertDidEmitValue(_ message: String = "Should have emitted at least one value.",
                                     file: StaticString = #file, line: UInt = #line) {
        XCTAssert(self.values.count > 0, message, file: file, line: line)
    }

    internal func assertDidNotEmitValue(_ message: String = "Should not have emitted any values.",
                                        file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(0, self.values.count, message, file: file, line: line)
    }
//
//    internal func assertDidTerminate(
//        _ message: String = "Should have terminated, i.e. completed/failed/interrupted.",
//        file: StaticString = #file, line: UInt = #line) {
//        XCTAssertTrue(self.didFail || self.didComplete || self.didInterrupt, message, file: file, line: line)
//    }
//
//    internal func assertDidNotTerminate(
//        _ message: String = "Should not have terminated, i.e. completed/failed/interrupted.",
//        file: StaticString = #file, line: UInt = #line) {
//        XCTAssertTrue(!self.didFail && !self.didComplete && !self.didInterrupt, message, file: file, line: line)
//    }

    internal func assertValueCount(_ count: Int, _ message: String? = nil,
                                   file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(count, self.values.count, message ?? "Should have emitted \(count) values",
            file: file, line: line)
    }
}

extension TestObserver where Value: Equatable {
    internal func assertValue(_ value: Value, _ message: String? = nil,
                              file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(1, self.values.count, "A single item should have been emitted.", file: file, line: line)
        XCTAssertEqual(value, self.lastValue, message ?? "A single value of \(value) should have been emitted",
            file: file, line: line)
    }

    internal func assertLastValue(_ value: Value, _ message: String? = nil,
                                  file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(value, self.lastValue, message ?? "Last emitted value is equal to \(value).",
            file: file, line: line)
    }

    internal func assertValues(_ values: [Value], _ message: String = "",
                               file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(values, self.values, message, file: file, line: line)
    }
}

extension TestObserver where Error: Equatable {}
