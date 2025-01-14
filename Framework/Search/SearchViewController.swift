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

final public class SearchViewController: UITableViewController, UISearchBarDelegate {

    public let modalLoaderType: ModalLoaderType
    public let vm = SearchViewModel()
    var outputs: SearchViewModel.Outputs!
    let dataSource = SearchHistoryTableViewDataSource()
    
    var clearOrCancelSearchHandler: (() -> ())?
    
    var didSelectArticleHandler: ((AutocompleteResult) -> ())?

    public init(modalLoaderType: ModalLoaderType) {
        self.modalLoaderType = modalLoaderType
        super.init(nibName: nil, bundle: nil)
        outputs = vm.outputs()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindStyles()
        bindViewModel()
        vm.inputs.viewDidLoadObserver.send(value: ())
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vm.inputs.searchTextChangedObserver.send(value: searchText)
    }
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        vm.inputs.cancelButtonTappedObserver.send(value: ())
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    func setupViews() {
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.defaultReusableId)
        tableView.delegate = self
        tableView.dataSource = dataSource
        navigationItem.title = "Søk".localized(key: "tab_search")

    }

    func setupConstraints() {
 
    }

    func bindStyles() {
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.backgroundColor = .tertiaryBackground
    }

    func bindViewModel() {

        outputs.articles.observeValues{ [weak self] articles in
            DispatchQueue.main.async {
                self?.dataSource.loadData(articles: articles)
                self?.tableView.reloadData()
            }
        }
        outputs!.searchCanceled.observeValues { [weak self] _ in
            self?.clearOrCancelSearchHandler?()
        }
        
        outputs!.showLoader.observeValuesForUI { [weak self] shouldShowLoader in
            guard let self else { return }
            ModalLoader.showOrHide(value: shouldShowLoader, inView: self.view, type: self.modalLoaderType)
        }
        
        outputs.dismissKeyboard.observeValues { [weak self] _ in
            self?.navigationController?.navigationItem.searchController?.searchBar.resignFirstResponder()
            self?.navigationItem.searchController?.searchBar.resignFirstResponder()
        }
        
        outputs.openArticle.observeValues{ [weak self] article in
            self?.didSelectArticleHandler?(article)
        }
        
    }
}

extension SearchViewController {

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.inputs.didSelectIndexPathObserver.send(value: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        vm.inputs.scrollViewWillBeingDraggingObserver.send(value: ())
    }
    
}

