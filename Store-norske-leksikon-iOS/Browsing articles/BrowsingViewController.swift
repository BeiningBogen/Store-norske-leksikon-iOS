//
//  BrowsingViewController.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 03/12/2018,49.
//  Copyright © 2018 Beining & Bogen. All rights reserved.
//

import UIKit
import Cartography

public class BrowsingViewController : UIViewController {

    let viewModel = BrowsingViewModel()

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindStyles()
        bindViewModel()
    }

    func setupViews() {

    }

    func setupConstraints() {
        constrain(view) { (viewProxy) in

        }
    }

    func bindStyles() {
        view.backgroundColor = .white
    }

    func bindViewModel() {
        viewModel.outputs.title.observeValues { [weak self] currentTitle in
            self?.title = currentTitle
        }
    }
}
