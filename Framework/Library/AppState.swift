//
//  AppState.swift
//  Search
//
//  Created by Håkon Bogen on 18/11/2019,47.
//  Copyright © 2019 Beining & Bogen. All rights reserved.
//

import Foundation

import ModelFramework
import Search
import ComposableArchitecture

public struct AppState {
    
    public var searchURL: String?
    public var searchResults: [Article]? = nil

    public init() {
        self.searchURL = nil
        self.searchResults = nil
    }
    
}

public enum AppAction {
    
    case detail(DetailStateAction)
    case searchAction(SearchAction)
    
    case nameListAction
    case syncWorkDone
    
    var detail: DetailStateAction? {
        get {
            guard case let .detail(value) = self else { return nil }
            return value
        }
        set {
            guard case .detail = self, let newValue = newValue else { return }
            self = .detail(newValue)
        }
    }
    
    public var searchAction: SearchAction? {
        get {
            guard case let .searchAction(value) = self else { return nil }
            return value
        }
        set {
            guard case .searchAction = self, let newValue = newValue else { return }
            self = .searchAction(newValue)
        }
        
    }
}

public extension AppState {
    
    var searchState : SearchState {
        get {
            return SearchState.init(searchResults: self.searchResults)
        }
        set {
            searchResults = newValue.searchResults
        }
    }
    
    
}
