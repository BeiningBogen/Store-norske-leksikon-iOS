//
//  URL.swift
//  Store-norske-leksikon-iOSFramework
//
//  Created by Håkon Bogen on 28/11/2022.
//  Copyright © 2022 Beining & Bogen. All rights reserved.
//

import UIKit
import WebKit

extension URL {
    /// Returns a request with an X-App header for `self`
    public func requestWithAppVersionHeader() -> URLRequest {
        var request = URLRequest(url: self)
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            request.setValue("app/iOS/\(appVersion)", forHTTPHeaderField: "X-App")
        }
        return request
    }
}

extension URLRequest {
    /// Returns a request with an X-App header for `self`
    public mutating func addAppVersionHeader()  {
        
    }
}

extension WKWebView {
    func setCustomUserAgent() {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.customUserAgent = "dk.lex.app/iOS/\(appVersion)"
        }
    }
}
