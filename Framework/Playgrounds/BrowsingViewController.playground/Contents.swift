import Foundation
import UIKit

import Store_norske_leksikon_iOSFramework


import PlaygroundSupport

// AppEnvironment.pushEnvironment(environment: Environment.init(service: Service.init(serverConfig: ServerConfig.init(baseURL: URL(string:Secrets.baseURL)!, basicHTTPAuth: BasicHTTPAuth.init(username: Secrets.qaUsername, password: Secrets.qaPassword)))))

let browsingViewController = BrowsingViewController.init(nibName: nil, bundle: nil)

PlaygroundPage.current.liveView = browsingViewController

PlaygroundPage.current.needsIndefiniteExecution = true





