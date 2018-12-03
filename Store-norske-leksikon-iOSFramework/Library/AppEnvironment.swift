import Foundation
import Store_norske_leksikon_iOSApi

public struct AppEnvironment {

    fileprivate static var stack: [Environment] = [Environment()]
    public static var current : Environment {
        return stack.last!
    }

    public static func pushEnvironment(environment: Environment) {
        stack.append(environment)
    }

    static func popEnvironment() {
        _ = stack.popLast()
    }

}
