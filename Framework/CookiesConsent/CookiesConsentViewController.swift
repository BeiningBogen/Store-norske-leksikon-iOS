//
//  CookiesConsentViewController.swift
//  Store-norske-leksikon-iOS
//
//  Created by Edouard Siegel on 13/08/2024.
//  Copyright © 2024 Beining & Bogen. All rights reserved.
//

import Foundation
import UIKit

public class CookiesConsentViewController: UIViewController { 

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "Cookies"
        tabBarItem = UITabBarItem(
            title: "Cookies".localized(
                key: "tab_cookies"
            ),

            image: UIImage(named: "TabBar/Cookies")?.resized(newSize: CGSize(width: 24, height: 24)),
            tag: 0
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
}
