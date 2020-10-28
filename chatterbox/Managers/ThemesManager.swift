import UIKit

class ThemesManager {

    static let shared = ThemesManager()
    private init() {}

    // MARK: - Properties
    private var currentTheme: ThemeModel?
    private var theme: ThemeModel {
        get {
            if let currentTheme = currentTheme {
                return currentTheme
            } else {
                let userModel = UserManager.shared.userModel
                guard let themeModel = ThemeModel(rawValue: userModel.theme.rawValue) else { return .classic }
                currentTheme = themeModel
                return themeModel
            }
        }
        set {
            currentTheme = newValue
        }
    }

    // MARK: - Colors
    var mainBGColor: UIColor {
        switch theme {
        case .classic, .day:
            return .white

        case .night:
            return .black
        }
    }

    var incomingMessageBGColor: UIColor {
        switch theme {
        case .classic:
            return UIColor(hex: "#DFDFDF")

        case .day:
            return UIColor(hex: "#EAEBED")

        case .night:
            return UIColor(hex: "#2E2E2E")
        }
    }

    var outgoingMessageTextColor: UIColor {
        switch theme {
        case .classic:
            return .black

        case .day, .night:
            return .white
        }
    }

    var outgoingMessageBGColor: UIColor {
        switch theme {
        case .classic:
            return UIColor(hex: "#DCF7C5")

        case .day:
            return UIColor(hex: "#4389F9")

        case .night:
            return UIColor(hex: "#5C5C5C")
        }
    }

    var textColor: UIColor {
        switch theme {
        case .classic, .day:
            return .black

        case .night:
            return .white
        }
    }

    var barItemColor: UIColor {
        switch theme {
        case .classic, .day:
            return .darkGray

        case .night:
            return .white
        }
    }

    var barColor: UIColor {
        switch theme {
        case .classic, .day:
            return UIColor(hex: "#F5F5F5")

        case .night:
            return UIColor(hex: "#1E1E1E")
        }
    }

    var keyBoard: UIKeyboardAppearance {
        switch theme {
        case .classic, .day:
            return .light

        case .night:
            return .dark
        }
    }

    // MARK: - Functions
    func saveThemeSettings(theme: ThemeModel, handler: @escaping (Result) -> Void) {
        guard theme != currentTheme else { return }
        var userModel = UserManager.shared.userModel
        userModel.theme = theme
        UserManager.shared.dataManager.updateModel(with: userModel) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.theme = UserManager.shared.userModel.theme

            case .error:
                return
            }
            handler(result)
        }
    }

    func setupNavigationBar(target: UIViewController) {
        switch theme {
        case .classic, .day:
            target.navigationController?.navigationBar.barStyle = .default

        case .night:
            target.navigationController?.navigationBar.barStyle = .blackTranslucent
        }
        target.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
    }
}
