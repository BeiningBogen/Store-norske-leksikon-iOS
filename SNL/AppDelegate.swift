import UIKit
import CoreData
import Store_norske_leksikon_iOSFramework
import MobileConsentsSDK
import Combine
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var cookiePopupCancellable: AnyCancellable?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        /*Do not run the application when the tests are running.*/
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil { return true }
        Current.appSettings = AppSettings(speechSynthesizedLanguage: TargetSpecificSettings.speechSynthesizedLanguage, searchBaseURL: TargetSpecificSettings.searchBaseURL, domTitleToBeStripped: TargetSpecificSettings.domTitleToBeStripped, mobileCookieConsentValues: MobileCookieConsentValues.readSecrets())
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabbarController = UITabBarController.init(nibName: nil, bundle: nil)
        UITabBar.appearance().tintColor = .secondaryBackground
        TargetSpecificSettings.setupAppearance()
        
        let browsingViewController = BrowsingViewController.init(nibName: nil, bundle: nil)
        let navControllerBrowsing = UINavigationController.init(rootViewController: browsingViewController)
        
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
        browsingViewController.splashScreen = SplashScreen.show(inWindow: window)!
        showCookiePopup(in: browsingViewController)
        observeCookieConsentPopup(in: browsingViewController)
   
        
        Current.api = Api.init(serverConfig: ServerConfig.init(baseURL: URL.init(string: TargetSpecificSettings.baseURL)!, basicHTTPAuth: nil))
        browsingViewController.vm.inputs.configureObserver.send(value: URL.init(string: TargetSpecificSettings.baseURL)!.requestWithAppVersionHeader())
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

extension AppDelegate {
    
    func showCookiePopup(in vc: BrowsingViewController) {
        /// Mobile consents SDK does not support being attached to the framework, only works inside the real target, there fore needs to be
        if let values = MobileCookieConsentValues.readSecrets() {
            let consents = MobileConsents(clientID: values.clientID, clientSecret: values.clientSecret, solutionId: values.solutionID, enableNetworkLogger: true)
            after(1.2) {
                consents.showPrivacyPopUpIfNeeded(onViewController: vc)
            }
        }
    }
    
    func observeCookieConsentPopup(in vc: BrowsingViewController) {
        cookiePopupCancellable = AppNotification.Publisher.didShowCookieConsentPopup().sink { _ in
            if let values = MobileCookieConsentValues.readSecrets() {
                let consents = MobileConsents(clientID: values.clientID, clientSecret: values.clientSecret, solutionId: values.solutionID, enableNetworkLogger: true)
                consents.showPrivacyPopUp(onViewController: vc)
            }
        }
            
    }
}
