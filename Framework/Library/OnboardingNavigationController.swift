//
//  OnboardingNavigationController.swift
//  Store-norske-leksikon-iOSFramework
//
//  Created by Håkon Bogen on 07/01/2020,2.
//  Copyright © 2020 Beining & Bogen. All rights reserved.
//

import Foundation
import UIKit

struct OnboardingState {
    
}

//struct AppState {
//
//    var count = 0
//    var url: URL? = URL.init(string: "snl.no")
//    var showError = false
//    var showMoreOptionsMenu = false
//
//    struct Activity {
//        let type: ActivityType
//        let timestamp = Date()
//
//        enum ActivityType {
//            case didBrowseToArticle(URL)
//            case didTapMoreOptionsButton
//        }
//    }
//}
//
//public enum BrowsingAction {
//    case tappedLink(URLRequest)
//    case moreButtonTapped
//}
//
//func browsingReducer(state: AppState, action: BrowsingAction) -> AppState {
//
//    switch action {
//
//    case .tappedLink(let urlRequest):
//        return AppState.init(count: state.count, url: urlRequest.url, showError: state.showError, showMoreOptionsMenu: state.showMoreOptionsMenu)
//
//    case .moreButtonTapped:
//        return AppState.init(count: state.count + 900, url: state.url, showError: state.showError, showMoreOptionsMenu: true)
//    }
//}
//
//final class Store<Value, Action> {
//
//    let reducer : (Value, Action) -> Value
//
//    var value: MutableProperty<Value>
//
//    init(value: MutableProperty<Value>, reducer: @escaping (Value, Action) -> Value) {
//        self.value = value
//        self.reducer = reducer
//    }
//
//    func send(_ action: Action) {
//        value.value = self.reducer(self.value.value, action)
//    }
//}
