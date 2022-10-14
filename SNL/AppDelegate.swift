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
        
        let tabbarController = UITabBarController.init(nibName: nil, bundle: nil)

        let browsingViewController = BrowsingViewController.init(nibName: nil, bundle: nil)
        let navControllerBrowsing = UINavigationController.init(rootViewController: browsingViewController)
        tabbarController.addChildViewController(navControllerBrowsing)
        let searchController = SearchHistoryViewController.init(style: .grouped)
        let navController = UINavigationController.init(rootViewController: searchController)
        navController.navigationBar.prefersLargeTitles = true
        
        let historyViewController = SearchViewController.init(nibName: nil, bundle: nil)
        searchController.navigationItem.searchController = UISearchController.init(searchResultsController: historyViewController)
        tabbarController.addChildViewController(navController)
        navController.tabBarItem = UITabBarItem.init(title: "Søk", image: UIImage.init(named: "search"), tag: 0)

        window?.backgroundColor = .white
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
        browsingViewController.splashScreen = SplashScreen.show(inWindow: window)
        

        Current.api = Api.init(serverConfig: ServerConfig.init(baseURL: URL.init(string: "https://snl.no")!, basicHTTPAuth: nil))
        
        browsingViewController.vm.inputs.configureObserver.send(value: URLRequest.init(url: URL.init(string: "https://snl.no")!))
        return true
    }
    

}
