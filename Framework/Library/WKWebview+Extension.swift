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
    
    func removeHeaderAndFooterOnDOMLoad(completionHandler: ((Any?, Error?) -> ())? = nil) {
        
        let javascript = """
        document.addEventListener('DOMContentLoaded', function(){
           var element = document.getElementsByTagName('header')[0];
           element.parentElement.removeChild(element);
           var element2 = document.getElementsByTagName('footer')[0];
           element2.parentElement.removeChild(element2);
        }, false);
        """
        self.evaluateJavaScript(javascript) { (response, error) in
            completionHandler?(response, error)
        }
            
    }
    
    func titleInDocument(completionHandler: @escaping ((String) -> ())) {
        let titleInDocument = """
        document.title;

        """
        
        self.evaluateJavaScript(titleInDocument) { (response, error) in
            if let stringResponse = response as? String {
                completionHandler(stringResponse.replacingOccurrences(of: " – Store norske leksikon", with: ""))
            }

        }
        
    }
    
}

