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

class SearchTableViewCell: UITableViewCell, ValueCell {

    static var defaultReusableId: String = String.init(describing: SearchTableViewCell.self)
    
    let vm = SearchTableViewCellViewModel()
    var titleLabel: UILabel!
    var cardBackgroundView: UIView!
    var excerptLabel: UILabel!
    var readWholeArticleLabel: UILabel!
    var previewImage: UIImageView!
    var arrowImageView: UIImageView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
        bindStyles()
        bindViewModel()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        previewImage?.image = nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWith(value: AutocompleteResult) {
        vm.inputs.configureWith(article: value)
        
    }

    func setupViews() {
        
        selectionStyle = .none
        titleLabel = UILabel.init(frame: .zero)
        titleLabel.numberOfLines = 2
        excerptLabel = UILabel.init(frame: .zero)
        previewImage = UIImageView.init(frame: .zero)
        previewImage.backgroundColor = .red
        cardBackgroundView = UIView.init(frame: .zero)
        readWholeArticleLabel = UILabel(frame: .zero)
        readWholeArticleLabel.text = "Les hele artikkelen".localized(key: "search_read_whole_article")
        arrowImageView = UIImageView.init(image: UIImage.init(named: "arrow"))
        
        previewImage.contentMode = .scaleAspectFill
        previewImage.clipsToBounds = true
        
        excerptLabel.numberOfLines = 3
        readWholeArticleLabel.textColor = .primaryTextColor
        
        cardBackgroundView.backgroundColor = .white
        cardBackgroundView.layer.shadowColor = UIColor.black.cgColor
        cardBackgroundView.layer.shadowRadius = 2
        cardBackgroundView.layer.shadowOffset = .init(width: 0, height: 1)
        cardBackgroundView.layer.shadowOpacity = 0.1
        
        backgroundColor = .secondaryBackground

        addSubview(cardBackgroundView)
        cardBackgroundView.addSubview(previewImage)
        cardBackgroundView.addSubview(titleLabel)
        cardBackgroundView.addSubview(excerptLabel)
        cardBackgroundView.addSubview(readWholeArticleLabel)
        cardBackgroundView.addSubview(arrowImageView)

    }
    
    func setupConstraints() {
        struct Layout {
            
            static let marginTop : CGFloat = 10
            static let marginLeft: CGFloat = 10
            static let marginBottom: CGFloat = 0
            static let marginRight: CGFloat = 10
            
            static let imageWidth: CGFloat = 97
            static let imageHeight: CGFloat = 97
            
        }
        
        constrain(self, cardBackgroundView, titleLabel, excerptLabel, previewImage, readWholeArticleLabel, arrowImageView) { cellProxy, cardBackgroundView, titleLabelProxy, excerptProxy, imageProxy, readWholeArticleProxy, arrowImageProxy  in
            
            cardBackgroundView.left == cellProxy.left
            cardBackgroundView.right == cellProxy.right
            cardBackgroundView.top == cellProxy.top + Layout.marginTop
            cardBackgroundView.bottom == cellProxy.bottom - Layout.marginBottom
            

            titleLabelProxy.top == cardBackgroundView.top + Layout.marginTop
            titleLabelProxy.left == cardBackgroundView.left + Layout.marginLeft
            titleLabelProxy.right == cardBackgroundView.right - Layout.marginRight
            
            titleLabelProxy.bottom == excerptProxy.top

            excerptProxy.top == titleLabelProxy.bottom + 5
            excerptProxy.left == titleLabelProxy.left
            excerptProxy.right == cardBackgroundView.right - Layout.marginRight
            
            readWholeArticleProxy.top == excerptProxy.bottom + 5
            readWholeArticleProxy.left == excerptProxy.left
            readWholeArticleProxy.bottom == cellProxy.bottom - 15
            
            arrowImageProxy.left == readWholeArticleProxy.right + 10
            arrowImageProxy.centerY == readWholeArticleProxy.centerY
            
           
//            imageProxy.width == Layout.imageWidth
//            imageProxy.height == Layout.imageHeight
//
//            imageProxy.right == cellProxy.right - Layout.marginRight
//            imageProxy.left == excerptProxy.right + Layout.marginLeft
//            imageProxy.top == titleLabelProxy.top + 10
//            imageProxy.bottom == readWholeArticleProxy.bottom - 10

        }
    }

    func bindStyles() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
    }

    func bindViewModel() {
        
        vm.outputs.title.observeValuesForUI { [weak self] title in
            self?.titleLabel.text = title
        }
        
        vm.outputs.excerpt.observeValuesForUI { [weak self] text in
            self?.excerptLabel.text = text
        }

        vm.outputs.imageURL.observeValuesForUI { [weak self] imageURL in
            
            guard let imageURL = imageURL else {
                self?.previewImage.image = nil
                return
            }
            
            if let url = URL.init(string: imageURL) {
                self?.previewImage.sd_setImage(with: url, completed: nil)
            }
        }
    }

}
