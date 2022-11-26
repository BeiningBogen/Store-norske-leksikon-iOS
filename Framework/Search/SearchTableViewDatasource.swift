//
//  SearchTableViewDatasource.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 11/12/2018,50.
//Copyright © 2018 Beining & Bogen. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class SearchTableViewDataSource: ValueCellDataSource {

    internal func loadData(articles: [Article]) {
        set(values: articles, cellClass: SearchTableViewCell.self, inSection: 0)
    }

    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        if let cell = cell as? SearchTableViewCell, let value = value as? Article {
            cell.configureWith(value: value)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tidligere søk".localized(key: "search_previous_searches")
    }
    
}
