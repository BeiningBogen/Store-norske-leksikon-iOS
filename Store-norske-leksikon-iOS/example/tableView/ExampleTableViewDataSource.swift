import Foundation
import ReactiveCocoa
import ReactiveSwift

class ExampleTableViewDataSource: ValueCellDataSource {
    
    internal func loadData(examples: [String]) {
        set(values: examples, cellClass: ExampleCell.self, inSection: 0)
    }
    
    internal func loadData(examples2: [String]) {
        set(values: examples2, cellClass: ExampleCell2.self, inSection: 1)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        if cell is ExampleCell {
            let exampleCell = cell as? ExampleCell
            if let value = value as? String {
                exampleCell?.configureWith(value: value)
            }
        }
        else if cell is ExampleCell2 {
            let exampleCell2 = cell as? ExampleCell2
            if let value = value as? String {
                exampleCell2?.configureWith(value: value)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Section 1" : "Secion 2"
    }
}
