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

final class SearchViewController: UIViewController {
    
    var tableView: UITableView!

    let vm = SearchViewModel()
    var outputs: SearchViewModel.Outputs!
    let dataSource = SearchTableViewDataSource()

    var didSelectArticleHandler: ((Article) -> ())?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        outputs = vm.outputs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindStyles()
        bindViewModel()
        vm.inputs.viewDidLoadObserver.send(value: ())
        
    }

    func setupViews() {
        
        tableView = UITableView.init(frame: .zero, style: .grouped)
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

        outputs.articles.observeValues{ [weak self] articles in
            DispatchQueue.main.async {
                self?.dataSource.loadData(articles: articles)
                self?.tableView.reloadData()
            }
        }
        
        outputs.openArticle.observeValues{ [weak self] article in
            self?.didSelectArticleHandler?(article)
            self?.dismiss(animated: true, completion: nil)
//            let viewController = BrowsingViewController.init(nibName: nil, bundle: nil)
//            viewController.vm.inputs.configureObserver.send(value: URLRequest.init(url: URL(string: article.articleURL)!))
//            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.inputs.didSelectIndexPathObserver.send(value: indexPath)
    }
    
}

extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vm.inputs.searchTextChangedObserver.send(value: searchText)
    }
}
