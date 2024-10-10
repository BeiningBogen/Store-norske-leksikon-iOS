//
//  SNLSettings.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 21/11/2022.
//  Copyright © 2022 Beining & Bogen. All rights reserved.
//

import Foundation
import UIKit
import Store_norske_leksikon_iOSFramework

// Settings for Store Norske Leksikon
struct TargetSpecificSettings {
    
    static let baseURL: String = "https://snl.no"

    /// The base URL used for search API
    static let searchBaseURL: String = "https://snl.no"
    
    static let speechSynthesizedLanguage: String = "nb-NO"
    static let domTitleToBeStripped: String = " – Store norske leksikon"
    static let displayCookiesButtonInTabBar: Bool = false

    static let preferedLoaderType = ModalLoaderType.multipleImagesSpinning

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
        customNavBarAppearance.backgroundColor = UIColor.init(named: "SecondaryBackground")
        UINavigationBar.appearance().scrollEdgeAppearance = customNavBarAppearance
        UINavigationBar.appearance().tintColor = .white
//        
        let appearance = UINavigationBar.appearance()
        appearance.scrollEdgeAppearance = customNavBarAppearance
        appearance.compactAppearance = customNavBarAppearance
        appearance.standardAppearance = customNavBarAppearance
        
        
        
        if #available(iOS 15.0, *) {
            appearance.compactScrollEdgeAppearance = customNavBarAppearance
        }
     
    }
}


