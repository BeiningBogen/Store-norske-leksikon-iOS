//
//  HistoryViewController.swift
//  Store-norske-leksikon-iOSFramework
//
//  Created by Håkon Bogen on 05/06/2019,23.
//  Copyright © 2019 Beining & Bogen. All rights reserved.
//

import Foundation
import UIKit
import Cartography

public class SearchHistoryViewController : UITableViewController, UISearchBarDelegate {
    
    
    public let vm = SearchHistoryViewModel()
    var outputs: SearchHistoryViewModel.Outputs!
    let dataSource = SearchTableViewDataSource()
    var didSelectArticleHandler: ((Article) -> ())?

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        outputs = vm.outputs()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    public override init(style: UITableViewStyle) {
        super.init(style: style)
        outputs = vm.outputs()
        tabBarItem = UITabBarItem.init(title: "Søk".localized(key: "tab_search"), image: UIImage.init(named: "search"), tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        outputs.articles.observeValues{ [weak self] articles in
            DispatchQueue.main.async {
                self?.dataSource.loadData(articles: articles)
                self?.tableView.reloadData()
            }
        }
        outputs.openArticle.observeValues{ [weak self] article in
            let viewController = BrowsingViewController.init(nibName: nil, bundle: nil)
            viewController.vm.inputs.configureObserver.send(value: URLRequest.init(url: URL(string: article.articleURL)!))
            self?.navigationController?.pushViewController(viewController, animated: true)
            self?.navigationController?.navigationBar.prefersLargeTitles = false
        }
        vm.inputs.viewDidLoadObserver.send(value: ())
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    
    func setupViews() {
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.defaultReusableId)
        tableView.dataSource = dataSource
        tableView.delegate = self
        definesPresentationContext = true
        navigationItem.title = "Søk".localized(key: "search_title")
        tabBarItem = UITabBarItem.init(title: "Søk".localized(key: "tabbar_search"), image: UIImage.init(named: "search"), tag: 0)
        navigationItem.searchController?.searchBar.delegate = self.navigationItem.searchController?.searchResultsController as! SearchViewController
        navigationItem.searchController?.searchBar.backgroundColor = .secondaryBackground
        navigationItem.searchController?.searchBar.backgroundColor = .primaryBackground
        navigationItem.searchController?.searchBar.searchTextField.textColor = .white
        navigationItem.searchController?.searchBar.tintColor = .white
        navigationItem.searchController?.searchBar.barTintColor = .white
        
        navigationItem.searchController?.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "",
            attributes: [.foregroundColor: UIColor.white]
        )
        navigationItem.searchController?.searchBar.searchTextField.leftView?.tintColor = .white
        
        view.backgroundColor = .secondaryBackground
        self.navigationController?.navigationBar.barTintColor = .secondaryBackground
        navigationController?.navigationBar.backgroundColor = .secondaryBackground
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        let searchViewController = (self.navigationItem.searchController?.searchResultsController as! SearchViewController)
        
        searchViewController.didSelectArticleHandler = { article in

            let viewController = BrowsingViewController.init(nibName: nil, bundle: nil)
            viewController.vm.inputs.configureObserver.send(value: URLRequest.init(url: URL(string: article.articleURL)!))
            self.navigationController?.pushViewController(viewController, animated: true)
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        searchViewController.clearOrCancelSearchHandler = {
            self.vm.inputs.searchClearedOrCanceledObserver.send(value: ())
            self.navigationItem.searchController?.searchBar.resignFirstResponder()
        }
        
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.inputs.didSelectIndexPathObserver.send(value: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backgroundView = UIView()
        let label = UILabel.init(frame: .zero)
        backgroundView.addSubview(label)
        label.textColor = .secondaryText

        backgroundView.backgroundColor = .secondaryBackground

        constrain(backgroundView, label) { backgroundView, label in
            backgroundView.height == 40
            backgroundView.width == UIScreen.main.bounds.width

            label.left == backgroundView.left + 10
            label.top == backgroundView.top
            label.bottom == backgroundView.bottom
        }
        label.text = "Tidligere søk".localized(key: "search_previous_results")

        return backgroundView
    }
    
}

