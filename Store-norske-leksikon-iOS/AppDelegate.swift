import UIKit
import CoreData
import Store_norske_leksikon_iOSFramework
import Store_norske_leksikon_iOSApi

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        /*Do not run the application when the tests are running.*/
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil { return true }
        
        AppEnvironment.pushEnvironment(environment: Environment.init(service: Service.init(serverConfig: ServerConfig.init(baseURL: URL(string:Secrets.baseURL)!, basicHTTPAuth: BasicHTTPAuth.init(username: Secrets.qaUsername, password: Secrets.qaPassword)))))

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let splitViewController =  UISplitViewController()

        let exampleViewController = BrowsingViewController.init(nibName: nil, bundle: nil)
        let rootNavigationController = UINavigationController(rootViewController: UIViewController.init(nibName: nil, bundle: nil))

        window?.backgroundColor = .white

        splitViewController.viewControllers = [rootNavigationController, exampleViewController /*Exchange this for your own viewcontroller*/]
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()

        return true
    }

}
