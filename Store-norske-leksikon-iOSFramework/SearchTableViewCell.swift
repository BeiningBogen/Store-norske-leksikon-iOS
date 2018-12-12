//
//  SearchTableViewCellCell.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 11/12/2018,50.
//Copyright © 2018 Beining & Bogen. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Cartography

class SearchTableViewCell: UITableViewCell, ValueCell {

    static var defaultReusableId: String = String.init(describing: SearchTableViewCell.self)
    
//    typealias Value = ReactiveSwift.Property<Mood>

    let vm = SearchTableViewCellCellViewModel()

//    var titleLabel: UILabel!
//    var imageView: UIImageView!
//    var clickableButton: UIButton!
//    var spinner: SpinnerView!

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//    }
//        setupViews()
//        addSubviews()
//        addGestures()
//        setupConstraints()
//        bindStyles()
//        bindViewModel()
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWith(value: ReactiveSwift.Property<String>) {
//        cm.configureWith(mood: value)
    }

    func setupViews() {
//        titleLabel = UILabel.init(frame: .zero)
//        imageView = UIImageView(frame: .zero)
//        clickableButton = UIButton(frame: .zero)
    }

    func addSubviews() {
//        addSubview(titleLabel)
//        addSubview(imageView)
//        addSubview(clickableButton)
    }

    func addGestures() {
//        clickableButton.addTarget(self, action: #selector(SearchTableViewCell.moodClicked), for: .touchUpInside)
    }

    func setupConstraints() {
//        constrain(self, titleLabel, imageView, clickableButton) { cellProxy, titleLabelProxy, imageViewProxy, clickableButtonProxy in
//            titleLabelProxy.left == cellProxy.left
//            titleLabelProxy.right == cellProxy.right
//            titleLabelProxy.bottom == cellProxy.bottom
//
//            imageViewProxy.top == cellProxy.top + 8
//            imageViewProxy.height == 60
//            imageViewProxy.width == 60
//            imageViewProxy.centerX == cellProxy.centerX
//
//            clickableButtonProxy.top == cellProxy.top
//            clickableButtonProxy.left == cellProxy.left
//            clickableButtonProxy.right == cellProxy.right
//            clickableButtonProxy.bottom == cellProxy.bottom
//        }
    }

    func bindStyles() {
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont.systemFont(ofSize: 13)
//        clickableButton.backgroundColor = .clear
    }

    func bindViewModel() {
//        vm.outputs.title.observeValues { [weak self] title in
//            self?.titleLabel.text = title
//        }
//
//        vm.outputs.image.observeValues { [weak self] image in
//            self?.imageView.image = image
//        }

//        vm.outputs.shouldAnimate.observeValues { [weak self] shouldAnimate in
//            guard let s = self else { return }

//            if shouldAnimate {
//                s.spinner.addOnTopOfMoodCollectionViewCell2(moodCollectionViewCell2: s)
//            } else {
//                s.spinner.removeFromSuperview()
//            }
//        }
    }

    @objc func moodClicked() {
//        vm.inputs.moodTapped()
    }

//    override func prepareForReuse() {
//        super.prepareForReuse()
//    }
}
