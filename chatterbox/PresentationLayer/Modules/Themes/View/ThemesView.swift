import UIKit

class ThemesView: UIView {

    // MARK: - UI
    lazy var classicThemeButton: ThemeButton = {
        let classicThemeButton = ThemeButton(title: NSLocalizedString("Classic", comment: ""),
                                             image: Images.classicTheme)
        return classicThemeButton
    }()

    lazy var dayThemeButton: ThemeButton = {
        let dayThemeButton = ThemeButton(title: NSLocalizedString("Day", comment: ""),
                                         image: Images.dayTheme)
        return dayThemeButton
    }()

    lazy var nightThemeButton: ThemeButton = {
        let nightThemeButton = ThemeButton(title: NSLocalizedString("Night", comment: ""),
                                           image: Images.nightTheme)
        return nightThemeButton
    }()

    func setupUIElements() {
        addSubviews(classicThemeButton, dayThemeButton, nightThemeButton)
        setupThemeButtonsViewConstraints()
    }

    // MARK: - Constraints
    private func setupThemeButtonsViewConstraints() {
        classicThemeButton.setupBasicConstraints()
        dayThemeButton.setupBasicConstraints()
        nightThemeButton.setupBasicConstraints()

        NSLayoutConstraint.activate([
            classicThemeButton.bottomAnchor.constraint(equalTo: dayThemeButton.topAnchor, constant: -84),
            dayThemeButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            nightThemeButton.topAnchor.constraint(equalTo: dayThemeButton.bottomAnchor, constant: 84)
        ])
    }
}
