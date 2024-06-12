//
//  Bundle.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 11/06/2024.
//  Copyright © 2024 Beining & Bogen. All rights reserved.
//

import Foundation
import Store_norske_leksikon_iOSFramework

private class BundleClass {}

enum APIKeys {
    
    case mobileConsentClientID
    case mobileConsentClientSecret
    case mobileConsentSolutionID
    
    var keyValue: String? {
        
        guard let plistPath = Bundle(for: BundleClass.self).path(forResource: "Secrets", ofType: "plist") else {
            return nil
        }
        
        // Read the contents of the plist file
        guard let plistData = FileManager.default.contents(atPath: plistPath) else {
            return nil
        }
        
        // Parse the plist data
        guard let plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] else {
            return nil
        }
        switch self {
            case .mobileConsentClientID:
                return plistDictionary?["MobileConsentClientID"] as? String
            case .mobileConsentClientSecret:
                return plistDictionary?["MobileConsentClientSecret"] as? String
            case .mobileConsentSolutionID:
                return plistDictionary?["MobileConsentSolutionID"] as? String
        }
    }
    
}
extension MobileCookieConsentValues {
    
    static func readSecrets() -> MobileCookieConsentValues? {
        guard let clientID = APIKeys.mobileConsentClientID.keyValue, let secret = APIKeys.mobileConsentClientSecret.keyValue, let solutionID = APIKeys.mobileConsentSolutionID.keyValue else {
            return nil
        }
        return MobileCookieConsentValues.init(clientID: clientID, clientSecret: secret, solutionID: solutionID)
    }
}

