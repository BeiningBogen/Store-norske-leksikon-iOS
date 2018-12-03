import Foundation
import ReactiveCocoa
import ReactiveSwift

//public class LastPerformedRequest {
//    public static var request: Any?
//}


public struct MockService : ServiceType {


    public static var lastPerformedRequest: Any?

    public var purchaseSubscriptionResponse: Void?
    public var purchaseSubscriptionError: RequestableError?

    public var serverConfig: ServerConfigType

    public init(serverConfig: ServerConfigType, purchaseSubscriptionResponse: Void? = nil, purchaseSubscriptionError: RequestableError? = nil) {

        self.purchaseSubscriptionResponse = purchaseSubscriptionResponse
        self.purchaseSubscriptionError = purchaseSubscriptionError
        self.serverConfig = serverConfig

    }

}
