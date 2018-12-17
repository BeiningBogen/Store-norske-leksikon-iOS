//
//  Templates.swift
//  Store-norske-leksikon-iOSTests
//
//  Created by Håkon Bogen on 17/12/2018,51.
//  Copyright © 2018 Beining & Bogen. All rights reserved.
//

import Foundation

@testable import Store_norske_leksikon_iOSApi

extension Article {
    
    static let template = Article.init(articleId: 1337, headword: "Sau", permalink: "https://snl.no/sau", rank: 0, snippet: "sauen tilhører slekten", firstTwoSentences: "Lorem")
    
}

extension MockService {
    
    static let template = MockService.init(serverConfig: ServerConfig.template)
    
}

extension ServerConfig {
    
    static let template = ServerConfig.local
    
}
