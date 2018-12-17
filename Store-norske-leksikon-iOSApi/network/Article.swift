//
//  Article.swift
//  Store-norske-leksikon-iOSApi
//
//  Created by Håkon Bogen on 12/12/2018,50.
//  Copyright © 2018 Beining & Bogen. All rights reserved.
//

import Foundation

public struct Article : Decodable {
    
    public private(set) var articleId: Int
    public private(set) var headword: String
    public private(set) var permalink: String
    public private(set) var rank: Float
    public private(set) var snippet: String
    public private(set) var firstTwoSentences: String
    
    enum CodingKeys: String, CodingKey {
        
        case articleId = "article_id"
        case headword
        case permalink
        case rank
        case snippet
        case firstTwoSentences = "first_two_sentences"
        
//        rticle_id    Artikkelens ID-nummer.
//        article_type_id    1: Vanlig artikkel, 2: Biografi, 3: Landartikkel, etc....
//        clarification    Presiseringsfelt for tittel
//        encyclopedia_id    Angir hvilket verk artikkelen tilhører. 1: SNL, (2: Meta,) 3: SML, 4: NBL
//        headword    Artikkelens tittel, eksklusive presisering.
//        permalink    Navnet som brukes i artikkelens URL
//        rank    Søkeresultat-rangeringstall. Bestemmes av hvor mange ganger søkeordet forekommer i artikkelen. Får bonuspoeng for perfekt treff i headword og i headword+clarification.
//        snippet    Utdrag fra første sted i artikkelen hvor søkefrasen forekommer.
//        taxonomy_id    ID-nummer for kategori i leksikonet. Kategoriene er tilgjengelige på https://[subdomene].snl.no/.taxonomy/[taxonomy_id]
//        taxonomy_title    Navnet på kategorien artikkelen ligger i.
//        article_url    URL til vanlig visning av artikkelen.
//        article_url_json    URL til json-representasjon av artikkelen.
//        title    Artikkelens fulle tittel.
    }
    
}
