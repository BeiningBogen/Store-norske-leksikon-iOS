//
//  Database.swift
//  Store-norske-leksikon-iOSFramework
//
//  Created by Håkon Bogen on 03/06/2019,23.
//  Copyright © 2019 Beining & Bogen. All rights reserved.
//

import Foundation

private func _fetchSearchHistory() -> [Article] {
    
    return [Article].fetch() ?? [Article]()
}

private func addToSearchHistory(_ article: Article) {
    var articles = _fetchSearchHistory()
    articles.insert(article, at: 0)
    articles.persist()
}

public struct Database {
    
    var fetchSearchHistory = _fetchSearchHistory
    var addToSearchHistory = addToSearchHistory(_:)
    
    public init() { }
    
}
