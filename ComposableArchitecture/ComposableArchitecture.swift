//
//  ComposableArchitecture.swift
//  ComposableArchitecture
//
//  Created by Håkon Bogen on 17/11/2019,46.
//  Copyright © 2019 Beining & Bogen. All rights reserved.
//

import Foundation
import ReactiveSwift

public func pullback<LocalValue, GlobalValue, GlobalAction, LocalAction>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return [] }
        let localEffects = reducer(&globalValue[keyPath: value], localAction)
        return localEffects.map { value in
            return value.map { localEffect in
                    var globalAction = globalAction
                    globalAction[keyPath: action] = localAction
                    return globalAction
                }
            }
        }
    }


public func logging<Value, Action>(
    _ reducer: @escaping Reducer<Value, Action>
) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducer(&value, action)
        let newValue = value
        return [.fireAndForget {
            print("Action: \(action)")
            print("Value:")
            dump(newValue)
            print("---")
            }] + effects
    }
}

public typealias Effect<A> = SignalProducer<A, Never>
public typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

public final class Store<Value, Action> {
    
    public let reducer: Reducer<Value, Action>
    public var value: MutableProperty<Value>
    private var compositeDisposable = CompositeDisposable()
    
    public init(initialValue: Value, reducer: @escaping Reducer<Value, Action>) {
        self.value = MutableProperty<Value>.init(initialValue)
        self.reducer = reducer
    }
    
    public func send(_ action: Action) {
        let effects = self.reducer(&self.value.value, action)
        effects.forEach { effect in
            compositeDisposable += effect.start()
        }
    }
    
    /// Also called view
    public func transform<LocalValue, LocalAction>(
        value toLocalValue: @escaping (Value) -> LocalValue,
        action toGlobalAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalValue, LocalAction> {
        let localStore = Store<LocalValue, LocalAction>(
            initialValue: toLocalValue(self.value.value),
            reducer:  { localValue, localAction in
                self.send(toGlobalAction(localAction))
                localValue = toLocalValue(self.value.value)
                return [] 
                
        }
            
        )
        localStore.compositeDisposable += self.value.signal.observeValues { [weak localStore] newValue in
            localStore?.value.value = toLocalValue(newValue)
        }
        return localStore
    }
}

public func combine<Value, Action>(
    _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
    return { value, action in
        return reducers.flatMap { $0(&value, action)}
    }
}

extension Effect {
    public static func fireAndForget(work: @escaping () -> Void) -> Effect<Value> {
        return Effect<Value> { observer , _  -> () in
            work()
            observer.sendCompleted()
        }
    }
    
    public static func sync(work: @escaping () -> Value) -> Effect<Value> {
      return Effect { observer, lifetime in
        observer.send(value:  work())
        observer.sendCompleted()
      }
    }
}
