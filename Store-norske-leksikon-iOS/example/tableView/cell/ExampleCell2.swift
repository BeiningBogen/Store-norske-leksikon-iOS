import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift
import Cartography

class ExampleCell2: UITableViewCell, ValueCell {

    static var defaultReusableId: String = String.init(describing: ExampleCell2.self)
    typealias Value = String

    var titleLabel: UILabel!

    let viewModel = ExampleCell2ViewModel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ExampleCell.defaultReusableId)
        setupViews()
        setupConstraints()
        bindStyles()
        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWith(value: String) {
        viewModel.configureWith(example: value)
    }

    func setupViews() {
        titleLabel = UILabel.init(frame: .zero)
        addSubview(titleLabel)
    }

    func setupConstraints() {
        constrain(self, titleLabel) { cellProxy, titleLabelProxy in
            titleLabelProxy.top == cellProxy.top
            titleLabelProxy.left == cellProxy.left
            titleLabelProxy.right == cellProxy.right
            titleLabelProxy.bottom == cellProxy.bottom
        }
    }

    func bindStyles() {
        titleLabel.textAlignment = .center
        backgroundColor = .blue
    }

    func bindViewModel() {
        viewModel.outputs.title.observeValues{ [weak self] title in
            self?.titleLabel.text = title
        }
    }
}
