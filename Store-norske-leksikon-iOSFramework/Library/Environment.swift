import Foundation
import Store_norske_leksikon_iOSApi

public struct Environment {

    // Endpoint towards
    public let apiService: ServiceType

    /// The amount of time to delay API requests by. Used primarily for testing. Default value is `0.0`.
    public let apiDelayInterval: DispatchTimeInterval

    public init(apiService: ServiceType = Service(), apiDelayInterval: DispatchTimeInterval = .seconds(0)) {

        self.apiService = apiService
        self.apiDelayInterval = apiDelayInterval

    }

}
