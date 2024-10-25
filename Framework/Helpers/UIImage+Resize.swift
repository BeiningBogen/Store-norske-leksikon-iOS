//
//  UIImage+Resize.swift
//  Store-norske-leksikon-iOS
//
//  Created by Edouard Siegel on 13/08/2024.
//  Copyright © 2024 Beining & Bogen. All rights reserved.
//

import UIKit

// Courtesy of https://stackoverflow.com/a/69173637, slightly trimmed down
extension UIImage {

    func resized(newSize: CGSize = .zero) -> UIImage {
        let size = newSize == .zero ? self.size : newSize
        let resizedImage = UIImage.create(size)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let renderer = UIGraphicsImageRenderer(size: size)
        let result = renderer.image { _ in
            resizedImage.draw(in: rect, blendMode: .normal, alpha: 1)
            draw(in: rect, blendMode: .destinationIn, alpha: 1)
        }
        return result
    }

    static func create(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: .zero, size: size)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
