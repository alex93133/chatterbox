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

    var themeModel: ThemeModel
    lazy var buttons = [themesView.classicThemeButton,
                        themesView.dayThemeButton,
                        themesView.nightThemeButton]

    typealias ConfigurationModel = ThemeModel

    // Delegate method
    weak var delegate: ThemesPickerDelegate?
    // Closure method
    var themeChangeHandler: (() -> Void)?

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
        UIView.animate(withDuration: 0.3) { [self] in
            view.backgroundColor = ThemesManager.shared.outgoingMessageBGColor
            buttons.forEach { $0.interactiveTitle.textColor = ThemesManager.shared.outgoingMessageTextColor }
            ThemesManager.shared.setupNavigationBar(target: self)
        }
    }

    // MARK: - Actions
    @objc
    private func classicThemeButtonPressed(sender: UIButton) {
        radioButtons(sender)
        ThemesManager.shared.theme = .classic
        applyNewTheme()

        // Delegate method
        // delegate?.updateColors()

        // Closure method
        themeChangeHandler?()

        /*
         If we are using self in non-escaping closures we can get retain cycles issue.
         It is connected with deallocation of the objects. In this case we don't have
         such functionality as DispatchSemaphore or DispatchQueue.asyncAfter etc.
         so we don't have to use [weak self].
         */
    }

    @objc
    private func dayThemeButtonPressed(sender: UIButton) {
        radioButtons(sender)
        ThemesManager.shared.theme = .day
        applyNewTheme()

        // Delegate method
        // delegate?.updateColors()

        // Closure method
        themeChangeHandler?()
    }

    @objc
    private func nightThemeButtonPressed(sender: UIButton) {
        radioButtons(sender)
        ThemesManager.shared.theme = .night
        applyNewTheme()

        // Delegate method
        // delegate?.updateColors()

        // Closure method
        themeChangeHandler?()
    }
}
