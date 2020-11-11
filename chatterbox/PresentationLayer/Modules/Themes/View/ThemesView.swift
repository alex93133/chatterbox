import UIKit

class ThemesView: UIView {

    // MARK: - UI
    lazy var classicThemeButton: ThemeButton = {
        let classicThemeButton = ThemeButton(title: NSLocalizedString("Classic", comment: ""),
                                             image: Images.classicTheme,
                                             themeService: themesService)
        return classicThemeButton
    }()

    lazy var dayThemeButton: ThemeButton = {
        let dayThemeButton = ThemeButton(title: NSLocalizedString("Day", comment: ""),
                                         image: Images.dayTheme,
                                         themeService: themesService)
        return dayThemeButton
    }()

    lazy var nightThemeButton: ThemeButton = {
        let nightThemeButton = ThemeButton(title: NSLocalizedString("Night", comment: ""),
                                           image: Images.nightTheme,
                                           themeService: themesService)
        return nightThemeButton
    }()

    func setupUIElements() {
        addSubviews(classicThemeButton, dayThemeButton, nightThemeButton)
        setupThemeButtonsViewConstraints()
    }

    // MARK: - Dependencies
    var themesService: ThemesServiceProtocol

    init(themesService: ThemesServiceProtocol) {
        self.themesService = themesService
        super.init(frame: UIScreen.main.bounds)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
