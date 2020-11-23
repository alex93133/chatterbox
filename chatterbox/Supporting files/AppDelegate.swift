import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?
    private let rootAssembly = RootAssembly()
    var isLaunchedBefore: Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            return true
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            return false
        }
    }

    // MARK: - App Lifecycle
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupStartScreen()
        disableDarkMode()
        setupNavigationBar()
        setDefaultUser()
        rootAssembly.loadUser()
        FirebaseApp.configure()
        return true
    }

    // MARK: - Functions
    private func setupStartScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let conversationsListViewController = rootAssembly.presentationAssembly.conversationListViewController()
        let navigationController = UINavigationController(rootViewController: conversationsListViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func disableDarkMode() {
        if #available(iOS 13, *) {
            window?.overrideUserInterfaceStyle = .light
        }
    }

    private func setupNavigationBar() {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .highlighted)
    }

    private func setDefaultUser() {
        guard !isLaunchedBefore else { return }
        rootAssembly.createDefaultUser()
    }
}
