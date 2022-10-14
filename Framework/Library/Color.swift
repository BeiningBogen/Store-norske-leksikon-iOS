//
//  Color.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 14/10/2022.
//  Copyright © 2022 Beining & Bogen. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let secondary = UIColor(hex: 0x0077A5)
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xff,
            green: (hex >> 8) & 0xff,
            blue: hex & 0xff,
            alpha: alpha
        )
    }
    
    public func asHex() -> String {
        let r: CGFloat = cgColor.components?[0] ?? 0.0
        let g: CGFloat = cgColor.components?[1] ?? 0.0
        let b: CGFloat = cgColor.components?[2] ?? 0.0

        return String(format: "#%02lX%02lX%02lX",
                      lroundf(Float(r * 255)),
                      lroundf(Float(g * 255)),
                      lroundf(Float(b * 255)))
    }
}

