import Foundation
import ReactiveSwift
import ReactiveCocoa

public struct Service : ServiceType {

    public let serverConfig: ServerConfigType

    public init(serverConfig: ServerConfig = .local) {
        self.serverConfig = serverConfig
    }
}
