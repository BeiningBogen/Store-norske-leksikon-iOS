//
//  SearchHistoryDataSource.swift
//  Store-norske-leksikon-iOSFramework
//
//  Created by Håkon Bogen on 05/06/2019,23.
//  Copyright © 2019 Beining & Bogen. All rights reserved.
//

import Foundation
import UIKit

class SearchHistoryTableViewDataSource: ValueCellDataSource {
    
    internal func loadData(articles: [Article]) {
        set(values: articles, cellClass: SearchTableViewCell.self, inSection: 0)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        if let cell = cell as? SearchTableViewCell, let value = value as? Article {
            cell.configureWith(value: value)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Søkeresultater"
    }
}
