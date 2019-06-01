//
//  SearchToolBar.swift
//  Store-norske-leksikon-iOSFramework
//
//  Created by Håkon Bogen on 24/12/2018,52.
//  Copyright © 2018 Beining & Bogen. All rights reserved.
//

import Foundation
import UIKit
import Cartography

class SearchToolbar : UIView {
    
    private var searchBar: UISearchBar
    
    var consrtraintGroup = ConstraintGroup()
    
    override init(frame: CGRect) {
        
        searchBar = UISearchBar(frame: CGRect.zero)
        super.init(frame: frame)
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.backgroundColor = UIColor.init(red: 0/255, green: 174/255, blue: 214/255, alpha: 1)
        self.addSubview(searchBar)
        searchBar.showsCancelButton = true

        constrain(self, searchBar) { selfP, searchP in
            
            searchP.left == selfP.left
            searchP.right == selfP.right
            searchP.top == selfP.top

        }
        
    }
    
    func setConstraints(isFirstResponder: Bool) {

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
