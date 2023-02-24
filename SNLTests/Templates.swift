//
//  Templates.swift
//  Store-norske-leksikon-iOSTests
//
//  Created by Håkon Bogen on 17/12/2018,51.
//  Copyright © 2018 Beining & Bogen. All rights reserved.
//

import Foundation

@testable import Store_norske_leksikon_iOSFramework

/// Templates are initialisers for structs that contain the minimum amount of info needed for the designated initializer
extension Article {

    static let template = Article.init(articleId: 0, headword: "", clarification: nil, permalink: "", rank: 0, snippet: "", imageURL: nil, articleURL: "", firstTwoSentences: "")
    
}
extension AutocompleteResult {

    static let template = AutocompleteResult.init(articleId: 0, title: "", excerpt: "", articleURL: "")
    
}

extension ServerConfig {
    
    static let template = ServerConfig.local
    
}
