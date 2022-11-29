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
//    static func show(inWindow: UIWindow?) -> UIView? {
//        <#code#>
//    }
    
    
    let logo1 = UIImageView.init(image: UIImage.init(named: "lex"))
    let logo2 = UIImageView.init(image: UIImage.init(named: "dk"))
    
    
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
    }
    
    public static func show(inWindow window: UIWindow?) -> SplashScreenProtocol? {
        guard let window = window else {
            return nil
        }
        
        let splashScreen = SplashScreen.init(frame: .zero)
        window.addSubview(splashScreen)
        splashScreen.addSubview(splashScreen.logo1)
        splashScreen.addSubview(splashScreen.logo2)
        
        
        constrain(splashScreen, window) { selfView, view in
            selfView.left == view.left
            selfView.top == view.top
            selfView.bottom == view.bottom
            selfView.right == view.right
        }
        
        /// Logo permanent constraints
        constrain(splashScreen, splashScreen.logo1, splashScreen.logo2) { selfView, logo1, logo2 in
            logo1.centerY == selfView.centerY - 50
            logo2.centerY == selfView.centerY - 50
        }
        
        /// Logo text animated constraint
        let logo1AnimationConstraint = constrain(splashScreen, splashScreen.logo1, splashScreen.logo2) { selfView, logo1, logo2 in
            logo1.right == selfView.left
        }
        let logo2AnimationConstraint = constrain(splashScreen, splashScreen.logo1, splashScreen.logo2) { selfView, logo1, logo2 in
            logo2.left == selfView.right
        }
        
            
        after(Constants.delayBeforeStartingAnimation) {
            if splashScreen.superview != nil {
                splashScreen.setNeedsUpdateConstraints()
                
                constrain(splashScreen, splashScreen.logo1, splashScreen.logo2, replace: logo1AnimationConstraint) { selfView, logo1, logo2 in
                    logo1.centerX == selfView.centerX - 40
                }
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                    splashScreen.layoutIfNeeded()
                    splashScreen.logo1.alpha = 1
                } completion: { _ in
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                        constrain(splashScreen, splashScreen.logo1, splashScreen.logo2, replace: logo2AnimationConstraint) { selfView, logo1, logo2 in
                            logo2.left == logo1.right + 5
                        }
                        splashScreen.layoutIfNeeded()
                    }
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
            self.logo1.alpha = 0
//            self.logoText.alpha = 0
            
        }) { _ in
            
        }
    }

    public func animateFadeout() {
        if self.logo1.alpha == 1 {
            UIView.animate(withDuration: Constants.logoFadeoutDuration, delay: 0.2, options: .curveEaseInOut, animations: {
                self.logo1.alpha = 0
                self.logo2.alpha = 0
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
