//
//  Templates.swift
//  Store-norske-leksikon-iOSTests
//
//  Created by Håkon Bogen on 17/12/2018,51.
//  Copyright © 2018 Beining & Bogen. All rights reserved.
//

import Foundation

@testable import Store_norske_leksikon_iOSFramework

extension Article {
    
    static let template = Article.init(articleId: 0, headword: "", permalink: "", rank: 0, snippet: "", imageURL: nil, articleURL: "", firstTwoSentences: "")
    
}

extension ServerConfig {
    static let template = ServerConfig.local
    
}
