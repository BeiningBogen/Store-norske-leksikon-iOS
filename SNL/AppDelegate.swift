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
        
        Current.appSettings = AppSettings(speechSynthesizedLanguage: TargetSpecificSettings.speechSynthesizedLanguage, searchBaseURL: TargetSpecificSettings.searchBaseURL)
//        application.statusBarStyle = .lightContent
//        window?.windowScene?.statusBarManager?.statusBarStyle = .lightContent
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabbarController = UITabBarController.init(nibName: nil, bundle: nil)
        TargetSpecificSettings.setupAppearance()
//        navigationController?.navigationBar.barTintColor = UIColor.magenta
//        navigationController?.navigationBar.backgroundColor = UIColor.primaryBackground
        
        let browsingViewController = BrowsingViewController.init(nibName: nil, bundle: nil)
        let navControllerBrowsing = UINavigationController.init(rootViewController: browsingViewController)
//        navControllerBrowsing.navigationBar.barTintColor = UIColor.green
        
        tabbarController.addChildViewController(navControllerBrowsing)
        let searchController = SearchHistoryViewController.init(style: .grouped)
        let navController = UINavigationController.init(rootViewController: searchController)
        navController.navigationBar.prefersLargeTitles = true
        
        let historyViewController = SearchViewController.init(nibName: nil, bundle: nil)
        searchController.navigationItem.searchController = UISearchController.init(searchResultsController: historyViewController)
        tabbarController.addChildViewController(navController)

        window?.backgroundColor = .white
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
        browsingViewController.splashScreen = SplashScreen.show(inWindow: window) as! any SplashScreenProtocol
        
        Current.api = Api.init(serverConfig: ServerConfig.init(baseURL: URL.init(string: TargetSpecificSettings.baseURL)!, basicHTTPAuth: nil))
        browsingViewController.vm.inputs.configureObserver.send(value: URLRequest.init(url: URL.init(string: TargetSpecificSettings.baseURL)!))
        /// Opening external URL
        if let activityDictionary = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] {
            for key in activityDictionary.keys {
                if let userActivity = activityDictionary[key] as? NSUserActivity {
                    if let url = userActivity.webpageURL {
                        browsingViewController.vm.inputs.browseAppOpenURLObserver.send(value: url)
                    }
                }
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL else {
            return false
        }
        if let tabbarController = window?.rootViewController as? UITabBarController {
            tabbarController.selectedIndex = 0
            if let navigationController = tabbarController.viewControllers?.first as? UINavigationController, let browsingViewController = navigationController.topViewController as? BrowsingViewController {
                browsingViewController.vm.inputs.browseAppOpenURLObserver.send(value: incomingURL)
            }
        }
        return true
    }

}
