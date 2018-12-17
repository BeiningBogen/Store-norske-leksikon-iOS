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
import SDWebImage
import Store_norske_leksikon_iOSApi

class SearchTableViewCell: UITableViewCell, ValueCell {

    static var defaultReusableId: String = String.init(describing: SearchTableViewCell.self)
    
    let vm = SearchTableViewCellViewModel()
    var titleLabel: UILabel!
    var excerptLabel: UILabel!
    var previewImage: UIImageView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        addGestures()
        setupConstraints()
        bindStyles()
        bindViewModel()
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWith(value: Article) {
        vm.inputs.configureWith(article: value)
        
    }

    func setupViews() {
        
        titleLabel = UILabel.init(frame: .zero)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        excerptLabel = UILabel.init(frame: .zero)
        previewImage = UIImageView.init(frame: .zero)
        previewImage.contentMode = .scaleAspectFit

        addSubview(titleLabel)
        addSubview(excerptLabel)
        addSubview(previewImage)
        
    }
    

    func addGestures() {
//        clickableButton.addTarget(self, action: #selector(SearchTableViewCell.moodClicked), for: .touchUpInside)
    }

    func setupConstraints() {
        struct Layout {
            
            static let marginTop : CGFloat = 10
            static let marginLeft: CGFloat = 10
            static let marginBottom: CGFloat = 10
            static let marginRight: CGFloat = 10
            
            static let imageWidth: CGFloat = 60
            static let imageHeight: CGFloat = 60
            
        }
        
        constrain(self, titleLabel, excerptLabel, previewImage) { cellProxy, titleLabelProxy, excerptProxy, imageProxy  in

            titleLabelProxy.top == cellProxy.top + Layout.marginTop
            titleLabelProxy.left == cellProxy.left + Layout.marginLeft
//            titleLabelProxy.right == cellProxy.right
            titleLabelProxy.bottom == excerptProxy.top

            excerptProxy.left == titleLabelProxy.left
//            excerptProxy.right ==
            excerptProxy.bottom == cellProxy.bottom - Layout.marginBottom
            
            imageProxy.width == Layout.imageWidth
            imageProxy.height == Layout.imageHeight
            
//            imageProxy.left == excerptProxy.left
            imageProxy.right == cellProxy.right - Layout.marginRight
            imageProxy.left == excerptProxy.right + Layout.marginRight
            imageProxy.top == titleLabelProxy.top
            imageProxy.bottom == excerptProxy.bottom


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

        SDWebImageDownloader.shared().username = Secrets.qaUsername
        SDWebImageDownloader.shared().password = Secrets.qaPassword
        
        vm.outputs.imageURL.observeValues { [weak self] imageURL in
            
            DispatchQueue.main.async {
                guard let imageURL = imageURL else {
                    self?.previewImage.image = nil
                    return
                }
                    
                if let url = URL.init(string: imageURL) {
                    self?.previewImage.sd_setImage(with: url, completed: nil)
                }
                
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
