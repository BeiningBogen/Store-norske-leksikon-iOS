//
//  SearchViewController.swift
//  Search
//
//  Created by Håkon Bogen on 18/11/2019,47.
//  Copyright © 2019 Beining & Bogen. All rights reserved.
//

import Foundation
import ModelFramework
import UIKit
import ComposableArchitecture
import ReactiveSwift

public func after(_ duration: Double, closure: @escaping () -> Void) {
    let delayTime = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)

    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        closure()
    }
}

public enum SearchAction {
    /// # User inputs
    ///
    /// Call when user writes text in search field
    case searchBarTextChanged(String)

    /// Call when an indexpath is selected
    case didSelectIndexPath(IndexPath)

    /// # Requests
    /// Emit when the search completed, an array of results `Article`
    case completedSearch([Article])
    
    /// Call when search failed, the reason
    case searchFailed(String)
    
}

public struct SearchState {
    
    /// Update when search results are recived from search request
    public var searchResults: [Article]?
    
    /// Update when error message should show
    public var errorMessage: (title: String, message: String)?
    
    
    /// Update when an article is selected
    public var selectedArticle: Article?
    
    public init(searchResults: [Article]? = nil) {
        self.searchResults = searchResults
    }
}

public func searchReducer(state: inout  SearchState, action: SearchAction) -> [Effect<SearchAction>] {
    
    switch action {
    case .searchBarTextChanged(let text):
        return [searchRequest(text: text)]

    case .searchFailed(_):
        state.errorMessage = (title: "Noe feil skjedde", message: "lol")

    case .completedSearch(let articles):
        state.searchResults = articles
        
    case .didSelectIndexPath(let indexPath):
        state.selectedArticle = state.searchResults![indexPath.row]
    }
    
    return []
}


func searchRequest(text: String) -> Effect<SearchAction> {
    
    return Effect { observer, _ in
        
        return Current.api.searchArticles(Requests.SearchArticlesRequestable.Path.init(searchWord: text, limit: 10, offset: 10)).startWithResult { result in

            switch result {
            case .success(let response):
                observer.send(value: .completedSearch(response))

            case .failure(let error):
                observer.send(value: .searchFailed(error.debugDescription))
            }
            observer.sendCompleted()
        }
    }
    
}

public class SearchViewController: UITableViewController {
   
    let store : Store<SearchState, SearchAction>
    
    public init(store: Store<SearchState, SearchAction>) {
        self.store = store
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        store.send(SearchAction.searchBarTextChanged("lol"))
    }
    
    func bindOutputs() {
        
        store.value.signal
            .map (\.searchResults)
            .observeValues { results in
                
        }
        
        store.value.signal
            .map (\.selectedArticle)
            .skipNil()
            .observeValues { article in
        }

    }
    
    func setupViews() {
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.defaultReusableId)
        tableView.delegate = self
        tableView.dataSource = dataSource
        navigationItem.title = "Søk"
    }
    
}

extension SearchViewController : UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        store.send(SearchAction.searchBarTextChanged(searchText))
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        vm.inputs.cancelButtonTappedObserver.send(value: ())
    }
    
}
