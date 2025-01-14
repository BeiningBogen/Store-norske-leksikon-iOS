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
    
    public let modalLoaderType: ModalLoaderType
    public let vm = SearchHistoryViewModel()
    var outputs: SearchHistoryViewModel.Outputs!
    let dataSource = SearchTableViewDataSource()
    var didSelectArticleHandler: ((Article) -> ())?
    
    public init(modalLoaderType: ModalLoaderType) {
        self.modalLoaderType = modalLoaderType
        super.init(style: .grouped)
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
            guard let self else { return }
            let viewController = BrowsingViewController(modalLoaderType: modalLoaderType)
            viewController.vm.inputs.configureObserver.send(value: URLRequest.init(url: URL(string: article.articleURL)!))
            self.navigationController?.pushViewController(viewController, animated: true)
            self.navigationController?.navigationBar.prefersLargeTitles = false
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
        tabBarItem = UITabBarItem.init(title: "Søk".localized(key: "tab_search"), image: UIImage.init(named: "search"), tag: 0)
        navigationItem.searchController?.searchBar.delegate = self.navigationItem.searchController?.searchResultsController as! SearchViewController
        //        navigationItem.searchController?.searchBar.backgroundColor = .tertiaryBackground
        //        navigationItem.searchController?.searchBar.backgroundColor = .secondaryBackground
        navigationItem.searchController?.searchBar.searchTextField.textColor = .black
        navigationItem.searchController?.searchBar.tintColor = .black
        navigationItem.searchController?.searchBar.barTintColor = .white
        
        
        navigationItem.searchController?.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "",
            attributes: [.foregroundColor: UIColor.black]
        )
        navigationItem.searchController?.searchBar.searchTextField.leftView?.tintColor = .black
        navigationItem.searchController?.searchBar.searchTextField.backgroundColor = .tertiaryBackground
        
        if let searchController = navigationItem.searchController {
            let searchBar = searchController.searchBar
            searchBar.tintColor = UIColor(red: 253, green: 253, blue: 254)
            
            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.tintColor = UIColor.black
            }
            
        }
        
        view.backgroundColor = .tertiaryBackground
        self.navigationController?.navigationBar.barTintColor = .tertiaryBackground
        navigationController?.navigationBar.backgroundColor = .tertiaryBackground
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        let searchViewController = (self.navigationItem.searchController?.searchResultsController as! SearchViewController)
        
        searchViewController.didSelectArticleHandler = { article in
            
            let viewController = BrowsingViewController(modalLoaderType: self.modalLoaderType)
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
        
        backgroundView.backgroundColor = .tertiaryBackground
        
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

