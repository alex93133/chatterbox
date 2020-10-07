import UIKit

class ThemesManager {

    static let shared = ThemesManager()
    private init() {}

    // MARK: - Properties
    private let defaults = UserDefaults.standard
    private let key = "Theme"
    private var currentTheme: ThemeModel?
    var theme: ThemeModel {
        get {
            if let currentTheme = currentTheme {
                return currentTheme
            } else {
                guard let themeString = defaults.object(forKey: key) as? String else { return .classic }
                guard let themeModel = ThemeModel(rawValue: themeString) else { return .classic }
                currentTheme = themeModel
                return themeModel
            }
        }
        set {
            saveThemeSettings(theme: newValue)
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

    // MARK: - Functions
    private func saveThemeSettings(theme: ThemeModel) {
        guard theme != currentTheme else { return }
        let themeString = theme.rawValue
        defaults.set(themeString, forKey: key)
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
