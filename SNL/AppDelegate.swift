import UIKit
import CoreData
import Store_norske_leksikon_iOSFramework

import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        /*Do not run the application when the tests are running.*/
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil { return true }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let exampleViewController = BrowsingViewController.init(nibName: nil, bundle: nil)
        exampleViewController.vm.inputs.configureObserver.send(value: URLRequest.init(url: URL.init(string: "https://snl.no")!))

        window?.backgroundColor = .white
        window?.rootViewController = UINavigationController(rootViewController: exampleViewController)
        window?.makeKeyAndVisible()

        Current.api = Api.init(serverConfig: ServerConfig.init(baseURL: URL.init(string: "https://snl.no")!, basicHTTPAuth: nil))
        return true
    }

}
