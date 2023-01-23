//
//  SplashScreen.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 13/10/2022.
//  Copyright © 2022 Beining & Bogen. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import CoreGraphics
import Store_norske_leksikon_iOSFramework

public class SplashScreen: UIView, SplashScreenProtocol {
    
    let logo = UIImageView.init(image: UIImage.init(named: "SNL-logo"))
    let logoText = UILabel.init(frame: .zero)
    
    private struct Constants {
        /// Time before the loader shows
        static let delayBeforeStartingAnimation: Double = 0.1
        
        /// Maximum delay to show this splash screen (in case no event is sent to dismiss it)
        static let maximumTimeToShowSplashScreen = 4.3
        static let logoFadeoutDuration = 0.4
        static let backgroundFadeoutDuration = 0.2
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primaryBackground
        logoText.text = "STORE NORSKE LEKSIKON"
        logoText.numberOfLines = 0
        logoText.font = UIFont.systemFont(ofSize: 32)
        logoText.textColor = .white
        logoText.alpha = 0
        logo.alpha = 0
    }
    
    public static func show(inWindow window: UIWindow?) -> SplashScreen? {
        guard let window = window else {
            return nil
        }
        
        let splashScreen = SplashScreen.init(frame: .zero)
        window.addSubview(splashScreen)
        splashScreen.addSubview(splashScreen.logo)
        splashScreen.addSubview(splashScreen.logoText)
        splashScreen.logoText.numberOfLines = 3
        
        
        
        constrain(splashScreen, window) { selfView, view in
            selfView.left == view.left
            selfView.top == view.top
            selfView.bottom == view.bottom
            selfView.right == view.right
        }
        
        /// Logo permanent constraints
        constrain(splashScreen, splashScreen.logo) { selfView, logo in
            logo.centerY == selfView.centerY - 50
        }
        /// Logo text permanent constraintts
        constrain(splashScreen, splashScreen.logo, splashScreen.logoText) { selfView, logo, logotext in
            logotext.centerY == logo.centerY + splashScreen.logo.image!.size.height + 40
            logotext.width == 160
        }
        
        
        /// Logo text animated constraint
        let logoTextLeftConstraint = constrain(splashScreen, splashScreen.logo, splashScreen.logoText) { selfView, logo, logoText in
            logo.left == selfView.left - splashScreen.logo.image!.size.width
            logoText.left == selfView.left + window.bounds.width
        }
        
        
            
        after(Constants.delayBeforeStartingAnimation) {
            if splashScreen.superview != nil {
                
                splashScreen.setNeedsUpdateConstraints()
                
                constrain(splashScreen, splashScreen.logo, splashScreen.logoText, replace: logoTextLeftConstraint) { selfView, logo, logoText in
                    logoText.centerX == selfView.centerX
                    logo.left == logoText.left
                }
                
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                    splashScreen.layoutIfNeeded()
                    splashScreen.logo.alpha = 1
                    splashScreen.logoText.alpha = 1
                } completion: { _ in
                    
                }
            }
        }
        
        after(Constants.maximumTimeToShowSplashScreen) {
            if splashScreen.superview != nil {
                splashScreen.animateFadeout()
            }
        }
        return splashScreen
    }
    
    func transitionToSpinner() {
        UIView.animate(withDuration: 0.2, animations: {
            self.logo.alpha = 0
            self.logoText.alpha = 0
            
        }) { _ in
            
        }
    }

    public func animateFadeout() {
        if self.logo.alpha == 1 {
            UIView.animate(withDuration: Constants.logoFadeoutDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.logo.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
                self.logo.alpha = 0
                self.logoText.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
                self.logoText.alpha = 0
            }) { _ in
                UIView.animate(withDuration: Constants.backgroundFadeoutDuration, animations: {
                    self.backgroundColor = .clear
                }) { _ in
                    self.removeFromSuperview()
                }
            }
        } else {
            UIView.animate(withDuration: Constants.backgroundFadeoutDuration, animations: {
                self.backgroundColor = .clear
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}

/// Asynchronously schedules execution on main thread after a given duration
///
/// - Parameters:
///   - duration: Time to wait before scheduling
///   - closure: Block to execute
public func after(_ duration: Double, closure: @escaping () -> Void) {
    let delayTime = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        closure()
    }
}
