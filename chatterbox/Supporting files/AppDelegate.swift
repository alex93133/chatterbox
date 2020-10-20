import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?
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

    private func setupNavigationBar() {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .highlighted)
    }

    private func setDefaultUser() {
        guard !isLaunchedBefore else { return }
        let user = UserModel(photo: nil,
                             name: "Daria Mikhal",
                             description: "Middle data analytic",
                             theme: .classic)
        let dataManager = GCDDataManager()
        dataManager.createUser(model: user)
    }
}
