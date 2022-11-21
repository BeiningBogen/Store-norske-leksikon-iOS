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
    
    /// Strips the header and footer elements from the DOM
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
    
    /// Injects a script to that strips out header and footer elements on event: DOM content loaded
    func removeHeaderAndFooterOnDOMLoad(completionHandler: ((Any?, Error?) -> ())? = nil) {
        
        let javascript = """
        document.addEventListener('DOMContentLoaded', function(){
           var element = document.getElementsByTagName('header')[0];
           element.parentElement.removeChild(element);
        
           var element2 = document.getElementsByClassName('home-link')[0];
           element2.parentElement.removeChild(element2);
        
           var element3 = document.getElementsByTagName('footer')[0];
           element3.parentElement.removeChild(element3);
        }, false);
        """
        self.evaluateJavaScript(javascript) { (response, error) in
            completionHandler?(response, error)
        }
    }
    
    /// Finds the title of the document, then a strips out the unecessary name of the encyclopedia
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

