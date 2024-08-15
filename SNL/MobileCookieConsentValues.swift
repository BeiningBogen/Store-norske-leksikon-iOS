//
//  MobileConsentSetup.swift
//  Store-norske-leksikon-iOS
//
//  Created by Håkon Bogen on 11/06/2024.
//  Copyright © 2024 Beining & Bogen. All rights reserved.
//

import Foundation
//import MobileConsentsSDK

public struct MobileCookieConsentValues {
    
    public let clientID: String
    public let clientSecret: String
    public let solutionID: String
    public init(clientID: String, clientSecret: String, solutionID: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.solutionID = solutionID
    }
}
