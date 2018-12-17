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
import Store_norske_leksikon_iOSApi

class SearchTableViewCell: UITableViewCell, ValueCell {

    static var defaultReusableId: String = String.init(describing: SearchTableViewCell.self)
    
    let vm = SearchTableViewCellViewModel()
    var titleLabel: UILabel!
    var excerptLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        addGestures()
        setupConstraints()
        bindStyles()
        bindViewModel()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWith(value: Article) {
        vm.inputs.configureWith(article: value)
        
    }

    func setupViews() {
        
        titleLabel = UILabel.init(frame: .zero)
        excerptLabel = UILabel.init(frame: .zero)
        titleLabel.text = "asdfasf"
        
        addSubview(titleLabel)
        addSubview(excerptLabel)
        
    }

    func addGestures() {
//        clickableButton.addTarget(self, action: #selector(SearchTableViewCell.moodClicked), for: .touchUpInside)
    }

    func setupConstraints() {
        constrain(self, titleLabel, excerptLabel) { cellProxy, titleLabelProxy, excerptProxy  in
            
            titleLabelProxy.left == cellProxy.left
//            titleLabelProxy.right == cellProxy.right
            titleLabelProxy.bottom == cellProxy.bottom
            
            excerptProxy.left == titleLabelProxy.right + 15
            excerptProxy.bottom == titleLabelProxy.bottom
            excerptProxy.top == titleLabelProxy.top
            excerptProxy.right == cellProxy.right
            

//            imageViewProxy.top == cellProxy.top + 8
//            imageViewProxy.height == 60
//            imageViewProxy.width == 60
//            imageViewProxy.centerX == cellProxy.centerX
//
//            clickableButtonProxy.top == cellProxy.top
//            clickableButtonProxy.left == cellProxy.left
//            clickableButtonProxy.right == cellProxy.right
//            clickableButtonProxy.bottom == cellProxy.bottom
        }
    }

    func bindStyles() {
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont.systemFont(ofSize: 13)
//        clickableButton.backgroundColor = .clear
    }

    func bindViewModel() {
        
        vm.outputs.title.observeValues { [weak self] title in
            DispatchQueue.main.async {
            self?.titleLabel.text = title
            }
        }
        
        vm.outputs.excerpt.observeValues { [weak self] text in
            DispatchQueue.main.async {
            self?.excerptLabel.text = text
            }
        }

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
