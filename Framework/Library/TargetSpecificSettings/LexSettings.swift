//
//  LexSettings.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 21/11/2022.
//  Copyright © 2022 Beining & Bogen. All rights reserved.
//

import Foundation
import UIKit
import Store_norske_leksikon_iOSFramework

/// Settigns for lex.dk app
struct TargetSpecificSettings {
    
    static let baseURL: String = "https://lex.dk"
    
    /// The base URL used for search API
    static let searchBaseURL: String = "https://denstoredanske.lex.dk"
    
    static let speechSynthesizedLanguage: String = "da-DK"
    static let domTitleToBeStripped: String = "| lex.dk – Den Store Danske"
    static let displayCookiesButtonInTabBar: Bool = true

    static let preferedLoaderType = ModalLoaderType.lottie

    static func setupAppearance() {
        
        let customNavBarAppearance = UINavigationBarAppearance()
        customNavBarAppearance.configureWithOpaqueBackground()
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        customNavBarAppearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)        
        
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.backgroundColor = UIColor.init(named: "PrimaryBackground")
        UINavigationBar.appearance().scrollEdgeAppearance = customNavBarAppearance
        UINavigationBar.appearance().tintColor = .white
        
        let appearance = UINavigationBar.appearance()
        appearance.scrollEdgeAppearance = customNavBarAppearance
        appearance.compactAppearance = customNavBarAppearance
        appearance.standardAppearance = customNavBarAppearance
        
        
        
        if #available(iOS 15.0, *) {
            appearance.compactScrollEdgeAppearance = customNavBarAppearance
        }
    }
    
}

