import Foundation

public struct Requests {
    
    public struct GetArticleRequestable : Requestable {
        
        public typealias Parameter = Never
        public typealias Response = Data
        public static let apiType: APIType = .noBaseURL
        public static let method: HTTPMethod = .get
        
        public struct Path: PathComponentsProvider {
            
            public typealias Query = Never

            let path : String

            public init(path: String) {
                self.path = path
            }
            
            public var pathComponents: (path: [String], query: Query?) {
                return (
                    [self.path],
                    nil
                )
            }
        }
    }
    
    
    public struct SearchArticlesRequestable : Requestable {
        
        public typealias Parameter = Never
        public typealias Response = Data
        public static let apiType: APIType = .noBaseURL
        public static let method: HTTPMethod = .get
        
        public struct Path: PathComponentsProvider {
            
            public typealias Query = SearchQuery
            
            let searchWord : String
            let query: Query
            
            public init(searchWord: String, query: Query) {
                self.searchWord = searchWord
                self.query = query
            }
            
            public var pathComponents: (path: [String], query: Query?) {
                return (
                    ["api", "v1", "search"],
                    query
                )
            }
            
        }
        
    }
    
    public struct SearchQuery : Encodable {
        
        let query: String
        let limit : Int?
        let offset : Int?

        public init(query: String, limit : Int? = nil, offset : Int? = nil) {
            
            self.query = query
            self.limit  = limit
            self.offset  = offset
            
        }
        
    }
    
}
//https://[subdomene].snl.no/api/v1/search?query=[søkefrase]&[parameter]

//Parameter    Forklaring
//query    Påkrevd. Spørreord, f.eks. "Tog", "Edvard Munch"
//limit    Ikke påkrevd. Maks. antall resultater, 1-10 er gyldige verdier, standard er 3
//offset    Ikke påkrevd. Brukes til å vise neste "side" med resultater, default er 0, inkrementer med verdien du satte i limit

