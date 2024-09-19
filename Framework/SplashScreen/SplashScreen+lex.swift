//
//  SplashScreen.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 13/10/2022.
//  Copyright © 2022 Beining & Bogen. All rights reserved.
//

import Foundation
import UIKit
import Store_norske_leksikon_iOSFramework
import Lottie

public class SplashScreen: UIView, SplashScreenProtocol {

    fileprivate lazy var starAnimationView = LottieAnimationView(name: "splashscreen_lex")
    fileprivate var animationIsDone = false

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
        starAnimationView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(starAnimationView)
        starAnimationView.topAnchor.constraint(equalTo: topAnchor, constant: 306).isActive = true
        starAnimationView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundColor = UIColor(white: 241.0 / 255.0, alpha: 1.0)
    }
    
    public static func show(inWindow window: UIWindow?) -> SplashScreenProtocol? {
        guard let window = window else {
            return nil
        }
        
        let splashScreen = SplashScreen.init(frame: window.frame)
        window.addSubview(splashScreen)

        after(Constants.delayBeforeStartingAnimation) {
            splashScreen.starAnimationView.play { completed in
                splashScreen.animationIsDone = true
                splashScreen.animateFadeout()
            }
        }
        return splashScreen
    }

    public func animateFadeout() {
        guard animationIsDone else { return }
        UIView.animate(withDuration: Constants.logoFadeoutDuration) {
            self.starAnimationView.alpha = 0
        } completion: { _ in
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
