//
//  SplashScreenProtocol.swift
//  Store-norske-leksikon-iOSFramework
//
//  Created by Håkon Bogen on 28/11/2022.
//  Copyright © 2022 Beining & Bogen. All rights reserved.
//

import Foundation
import UIKit

public protocol SplashScreenProtocol: UIView {
    static func show(inWindow: UIWindow?) -> SplashScreenProtocol?
    func animateFadeout()
}
