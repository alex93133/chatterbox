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
        setupCoreData()
        FirebaseApp.configure()
        rootAssembly.servicesAssembly.userDataService.loadUser()
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
        let uuid = UUID().uuidString
        let user = User(photo: nil,
                        name: "Alexander Lazarev",
                        description: "Junior iOS dev",
                        theme: .classic,
                        uuID: uuid)
        rootAssembly.servicesAssembly.userDataService.dataManager.createUser(model: user)
    }

    #warning("Поправить")
    private func setupCoreData() {
        rootAssembly.servicesAssembly.coreDataService.enableStatisticts()
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }
}
