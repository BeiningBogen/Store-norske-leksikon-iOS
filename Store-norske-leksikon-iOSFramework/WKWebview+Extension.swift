//
//  WKWebview+Extension.swift
//  Store-norske-leksikon-iOSFramework
//
//  Created by Håkon Bogen on 09/12/2018,49.
//  Copyright © 2018 Beining & Bogen. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
    
    func removeHeaderAndFooter(completionHandler: ((Any?, Error?) -> ())? = nil) {

        let removeElementIdScript = """
        var element = document.getElementsByTagName('header')[0];
        element.parentElement.removeChild(element);
        var element2 = document.getElementsByTagName('footer')[0];
        element2.parentElement.removeChild(element2);
        """
        
        self.evaluateJavaScript(removeElementIdScript) { (response, error) in
           completionHandler?(response, error)
        }
        
    }
    
}

