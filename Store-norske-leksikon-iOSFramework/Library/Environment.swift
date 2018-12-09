import Foundation
import Store_norske_leksikon_iOSApi

public struct Environment {

    // Endpoint towards
    public let service: ServiceType

    /// The amount of time to delay API requests by. Used primarily for testing. Default value is `0.0`.
    public let apiDelayInterval: DispatchTimeInterval

    public init(service: ServiceType = Service(), apiDelayInterval: DispatchTimeInterval = .seconds(0)) {

        self.service = service
        self.apiDelayInterval = apiDelayInterval

    }

}
