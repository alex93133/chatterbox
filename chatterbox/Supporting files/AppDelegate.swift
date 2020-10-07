import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - App Lifecycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupStartScreen()
        disableDarkMode()
        return true
    }

    // MARK: - Functions
    private func setupStartScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let conversationsListViewController = ConversationsListViewController()
        let navigationController = UINavigationController(rootViewController: conversationsListViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func disableDarkMode() {
        if #available(iOS 13, *) {
            window?.overrideUserInterfaceStyle = .light
        }
    }
}
