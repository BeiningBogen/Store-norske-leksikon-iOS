//
//  String+Extension.swift
//  Store-norske-leksikon-iOSFramework
//
//  Created by Håkon Bogen on 27/08/2019,35.
//  Copyright © 2019 Beining & Bogen. All rights reserved.
//

import Foundation

extension String {
    
    func stripOutHtml() -> String? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }
}
