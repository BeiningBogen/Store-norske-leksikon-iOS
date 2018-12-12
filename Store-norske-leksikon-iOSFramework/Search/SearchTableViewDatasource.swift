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

    internal func loadData(examples: [String]) {
//        set(values: examples, cellClass: SearchTableViewCell.self, inSection: 0)
    }

    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
//        if let cell = cell as SearchTableViewCell {
//            if let value = value as? String {
//                cell.configureWith(value: value)
//            }
//        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return section == 0 ? "Section 1" : "Secion 2"
        return nil
    }
}
