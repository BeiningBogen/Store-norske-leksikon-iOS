//
//  Article.swift
//  Store-norske-leksikon-iOSApi
//
//  Created by Håkon Bogen on 12/12/2018,50.
//  Copyright © 2018 Beining & Bogen. All rights reserved.
//

import Foundation

public struct Article : Decodable {
    
    public private(set) var name: String
    public private(set) var headword: String
    public private(set) var permalink: String
    public private(set) var rank: Int
    public private(set) var snippet: String
    public private(set) var firstTwoSentences: String
    
}
