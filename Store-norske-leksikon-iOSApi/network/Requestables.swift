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
}
