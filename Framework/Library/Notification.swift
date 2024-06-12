//
//  Notification.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 12/06/2024.
//  Copyright © 2024 Beining & Bogen. All rights reserved.
//

import Foundation

public struct AppNotification {
    private enum Name: String {
        case showCookieConsentPopup

        var NSNotificationName: NSNotification.Name {
            return NSNotification.Name.init(self.rawValue)
        }
    }
    
    public struct Post {
        
        public static func showCookieConsentPopup() {
            NotificationCenter.default.post(name: Name.showCookieConsentPopup.NSNotificationName, object: nil)
        }
        
    }
    
    public struct Publisher {
        
        public static func didShowCookieConsentPopup() -> NotificationCenter.Publisher {
            return NotificationCenter.default.publisher(for: Name.showCookieConsentPopup.NSNotificationName)
        }
        
    }
    
}
