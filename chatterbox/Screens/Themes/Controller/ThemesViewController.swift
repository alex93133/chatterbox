import UIKit

protocol ThemesPickerDelegate: class {
    func updateColors()
}

class ThemesViewController: UIViewController, ConfigurableView {

    // MARK: - Properties
    private let themesView: ThemesView = {
        let view = ThemesView(frame: UIScreen.main.bounds)
        return view
    }()

    private var themeModel: ThemeModel
    private lazy var buttons = [themesView.classicThemeButton,
                                themesView.dayThemeButton,
                                themesView.nightThemeButton]

    typealias ConfigurationModel = ThemeModel

    weak var delegate: ThemesPickerDelegate?

    init(with themeModel: ThemeModel) {
        self.themeModel = themeModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Lifecycle
    override func loadView() {
        view = themesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        configure(with: themeModel)
    }

    // MARK: - Functions
    private func setupView() {
        themesView.setupUIElements()
        themesView.backgroundColor = ThemesManager.shared.outgoingMessageBGColor

        themesView.classicThemeButton.addTarget(self, action: #selector(classicThemeButtonPressed), for: .touchUpInside)
        themesView.dayThemeButton.addTarget(self, action: #selector(dayThemeButtonPressed), for: .touchUpInside)
        themesView.nightThemeButton.addTarget(self, action: #selector(nightThemeButtonPressed), for: .touchUpInside)
    }

    private func setupNavigationBar() {
        navigationItem.title = NSLocalizedString("Settings", comment: "")
    }

    func configure(with model: ConfigurationModel) {
        switch model {
        case .classic:
            themesView.classicThemeButton.isSelected = true

        case .day:
            themesView.dayThemeButton.isSelected = true

        case .night:
            themesView.nightThemeButton.isSelected = true
        }
    }

    private func radioButtons(_ sender: UIButton) {
        buttons.forEach {
            if $0 == sender {
                $0.isSelected = true
            } else {
                $0.isSelected = false
            }
        }
    }

    private func applyNewTheme() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = ThemesManager.shared.outgoingMessageBGColor
            self.buttons.forEach { $0.interactiveTitle.textColor = ThemesManager.shared.outgoingMessageTextColor }
            ThemesManager.shared.setupNavigationBar(target: self)
        }
    }

    private func handleThemeSaving(_ result: Result) {
        DispatchQueue.main.async {
            self.delegate?.updateColors()
            switch result {
            case .success:
                self.applyNewTheme()
                Logger.shared.printLogs(text: "Theme successfully changed to \(UserManager.shared.userModel.theme.rawValue)")

            case .error:
                Logger.shared.printLogs(text: "Theme changing error")
            }
        }
    }

    // MARK: - Actions
    @objc
    private func classicThemeButtonPressed(sender: UIButton) {
        radioButtons(sender)

        ThemesManager.shared.saveThemeSettings(theme: .classic) { [weak self] result in
            guard let self = self else { return }
            self.handleThemeSaving(result)
        }
    }

    @objc
    private func dayThemeButtonPressed(sender: UIButton) {
        radioButtons(sender)

        ThemesManager.shared.saveThemeSettings(theme: .day) { [weak self] result in
            guard let self = self else { return }
            self.handleThemeSaving(result)
        }
    }

    @objc
    private func nightThemeButtonPressed(sender: UIButton) {
        radioButtons(sender)

        ThemesManager.shared.saveThemeSettings(theme: .night) { [weak self] result in
            guard let self = self else { return }
            self.handleThemeSaving(result)
        }
    }
}
