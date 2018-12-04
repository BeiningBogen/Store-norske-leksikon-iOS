import Foundation

public struct Requests {
    
    struct GetArticleRequestable : Requestable {
        
        public typealias Parameter = Never
        public typealias Response = String
        public static let apiType: APIType = .standard
        public static let method: HTTPMethod = .get
        
        public struct Path: PathComponentsProvider {
            
            public typealias Query = Never

            public init() {
                
            }
            
            public var pathComponents: (path: [String], query: Query?) {
                return (
                    [String](),
                    nil
                )
            }
        }
    }
}
