import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - App Lifecycle
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //        printLogs(text: "Application has been loaded. State now is inactive: \(#function)")
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ProfileViewController()
        window?.makeKeyAndVisible()

        if #available(iOS 13, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //        printLogs(text: "Application change state from inactive to active: \(#function)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //        printLogs(text: "Application change state from active to inactive: \(#function)")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //        printLogs(text: "Application change state from inactive to background: \(#function)")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        //        printLogs(text: "Application change state from background to inactive: \(#function)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        //        printLogs(text: "Application change state from background and now has been suspended: \(#function)")
    }
}

/// Method print logs depends on building configuration
public func printLogs(text: String) {
    #if DEBUG
    print(text)
    #endif
}
