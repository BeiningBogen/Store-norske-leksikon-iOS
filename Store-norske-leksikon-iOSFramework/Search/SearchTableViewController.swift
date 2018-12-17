//
//  SearchTableViewController.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 11/12/2018,50.
//Copyright © 2018 Beining & Bogen. All rights reserved.
//

import UIKit
import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result
import Cartography
import Store_norske_leksikon_iOSApi

final class SearchTableViewController: UIViewController {
    
    var tableView: UITableView!

    let vm = SearchTableViewModel()
    let dataSource = SearchTableViewDataSource()

    
    var didSelectHandler: ((Article) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindStyles()
        bindViewModel()
        vm.inputs.viewDidLoad()
    }

    func setupViews() {
        
        tableView = UITableView.init(frame: .zero)
        view.addSubview(tableView)
        navigationItem.title = "Artikkelsøk"
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.defaultReusableId)
        tableView.delegate = self
        tableView.dataSource = dataSource
        
    }

    func setupConstraints() {
        
        constrain(view, tableView) { viewProxy, tableViewProxy in
            tableViewProxy.top == viewProxy.top
            tableViewProxy.left == viewProxy.left
            tableViewProxy.right == viewProxy.right
            tableViewProxy.bottom == viewProxy.bottom
        }
        
    }

    func bindStyles() {
        tableView.backgroundColor = .white
    }

    func bindViewModel() {
        vm.outputs.articles.observeValues{ [weak self] articles in
            
            DispatchQueue.main.async {
                self?.dataSource.loadData(articles: articles)
                self?.tableView.reloadData()
            }
        }
        
        vm.outputs.didSearchForArticle.observeValues { [weak self] article in
            self?.didSelectHandler?(article)
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

extension SearchTableViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.inputs.didSelect(indexPath: indexPath)
    }
    
}

extension SearchTableViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vm.inputs.searchTextChanged(text: searchText)
    }
}

extension SearchTableViewController : UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("lol")
    }
    
}
