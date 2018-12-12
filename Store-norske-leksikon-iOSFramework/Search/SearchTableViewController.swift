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

final class SearchTableViewController: UIViewController {
    
    var tableView: UITableView!

    let vm = SearchTableViewModel()
    let dataSource = SearchTableViewDataSource()

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
        vm.outputs.cells.observeValues{ [weak self] cells in
            self?.dataSource.loadData(examples: cells)
            self?.tableView.reloadData()
        }
    }
}

extension SearchTableViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension SearchTableViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

extension SearchTableViewController : UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("lol")
    }
    
}
