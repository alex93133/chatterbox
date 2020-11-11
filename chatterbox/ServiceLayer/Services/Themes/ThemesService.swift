import UIKit

protocol ThemesServiceProtocol: ThemesServiceColorsProtocol {
    var theme: Theme { get set }
    var keyboardStyle: UIKeyboardAppearance { get }
    func setupNavigationBar(target: UIViewController)
}

protocol ThemesServiceColorsProtocol {
    var mainBGColor: UIColor { get }
    var incomingMessageBGColor: UIColor { get }
    var outgoingMessageTextColor: UIColor { get }
    var outgoingMessageBGColor: UIColor { get }
    var textColor: UIColor { get }
    var barItemColor: UIColor { get }
    var barColor: UIColor { get }
}

class ThemesService: ThemesServiceProtocol {

    // MARK: - Dependencies
    var userDataService: UserDataServiceProtocol

    init(userDataService: UserDataServiceProtocol) {
        self.userDataService = userDataService
    }

    // MARK: - Properties
    private var currentTheme: Theme?
    var theme: Theme {
        get {
            if let currentTheme = currentTheme {
                return currentTheme
            } else {
                let userModel = userDataService.userModel
                guard let themeModel = Theme(rawValue: userModel.theme.rawValue) else { return .classic }
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

    var keyboardStyle: UIKeyboardAppearance {
        switch theme {
        case .classic, .day:
            return .light

        case .night:
            return .dark
        }
    }

    // MARK: - Functions
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
