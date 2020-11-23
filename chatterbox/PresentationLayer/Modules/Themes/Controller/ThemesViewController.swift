import UIKit

protocol ThemesPickerDelegate: class {
    func updateColors()
}

class ThemesViewController: UIViewController, ConfigurableView {

    // MARK: - Properties
    lazy var themesView: ThemesView = {
        let view = ThemesView(themesService: model.themesService)
        return view
    }()

    private var themeModel: Theme
    private lazy var buttons = [themesView.classicThemeButton,
                                themesView.dayThemeButton,
                                themesView.nightThemeButton]

    typealias ConfigurationModel = Theme

    weak var delegate: ThemesPickerDelegate?

    // MARK: - Dependencies
    var model: ThemesModelProtocol
    var presentationAssembly: PresentationAssemblyProtocol

    init(model: ThemesModelProtocol, presentationAssembly: PresentationAssemblyProtocol) {
        self.themeModel = model.theme
        self.model = model
        self.presentationAssembly = presentationAssembly
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
        themesView.backgroundColor = model.themesService.outgoingMessageBGColor

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
        delegate?.updateColors()
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = self.model.themesService.outgoingMessageBGColor
            self.buttons.forEach { $0.interactiveTitle.textColor = self.model.themesService.outgoingMessageTextColor }
            self.model.themesService.setupNavigationBar(target: self)
        }
    }

    private func saveTheme(newTheme: Theme) {
        var userModel = model.userDataService.userModel
        guard newTheme != userModel.theme else { return }
        userModel.theme = newTheme
        model.userDataService.dataManager.updateModel(with: userModel) { [weak self] result in
            guard let self = self else { return }
            self.handleThemeSaving(result)
        }
    }

    private func handleThemeSaving(_ result: Result<User>) {
        DispatchQueue.main.async {
            switch result {
            case .success (let user):
                self.model.userDataService.userModel = user
                self.model.themesService.theme = user.theme
                self.applyNewTheme()
                Logger.shared.printLogs(text: "Theme successfully changed to \(self.model.userDataService.userModel.theme.rawValue)")

            case .error:
                Logger.shared.printLogs(text: "Theme changing error")
            }
        }
    }

    // MARK: - Actions
    @objc
    private func classicThemeButtonPressed(sender: UIButton) {
        radioButtons(sender)
        saveTheme(newTheme: .classic)
    }

    @objc
    private func dayThemeButtonPressed(sender: UIButton) {
        radioButtons(sender)
        saveTheme(newTheme: .day)
    }

    @objc
    private func nightThemeButtonPressed(sender: UIButton) {
        radioButtons(sender)
        saveTheme(newTheme: .night)
    }
}
