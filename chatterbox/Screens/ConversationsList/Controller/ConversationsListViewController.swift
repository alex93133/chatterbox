import UIKit

class ConversationsListViewController: UIViewController {

    // MARK: - Properties
    private let customView = ConversationsListView(frame: UIScreen.main.bounds)

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }

    // MARK: - Functions
    private func setupView() {
        customView.setupUIElements()
        view                            = customView
        customView.backgroundColor      = ThemesManager.shared.mainBGColor
        customView.tableView.delegate   = self
        customView.tableView.dataSource = self
    }

    private func setupNavigationBar() {
        ThemesManager.shared.setupNavigationBar(target: self)
        navigationItem.title = "Tinkoff Chat"
        let settingsUIBarButtonItem = UIBarButtonItem(image: Images.settings,
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(settingsItemPressed))
        settingsUIBarButtonItem.tintColor = ThemesManager.shared.barItemColor
        navigationItem.leftBarButtonItem = settingsUIBarButtonItem

        let image = UserManager.shared.currentUserModel.accountIcon
        let accountButton = UIBarButtonItem.roundedButton(from: image,
                                                          target: self,
                                                          action: #selector(accountItemPressed))
        navigationItem.rightBarButtonItem = accountButton
    }

    private func applyNewTheme() {
        customView.tableView.backgroundColor        = ThemesManager.shared.mainBGColor
        customView.backgroundColor                  = ThemesManager.shared.mainBGColor
        navigationItem.leftBarButtonItem?.tintColor = ThemesManager.shared.barItemColor
        customView.tableView.reloadData()
        guard let cells = customView.tableView.visibleCells as? [ConversationTableViewCell] else { return }
        cells.forEach { $0.nameLabel.textColor = ThemesManager.shared.textColor }
    }

    // MARK: - Actions
    @objc
    private func settingsItemPressed() {
        let theme = ThemesManager.shared.theme
        let themesViewController = ThemesViewController(with: theme)
        themesViewController.delegate = self
        // Closure method
        themesViewController.themeChangeHandler = { [self] in
            applyNewTheme()
        }
        navigationController?.pushViewController(themesViewController, animated: true)
    }

    @objc
    private func accountItemPressed() {
        let profileModel                             = UserManager.shared.currentUserModel
        let profileViewController                    = ProfileViewController(with: profileModel)
        profileViewController.modalPresentationStyle = .popover
        present(profileViewController, animated: true)
    }
}

// MARK: - Delegates
extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return HardcodedStorage.shared.sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return HardcodedStorage.shared.sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HardcodedStorage.shared.sections[section].conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.conversationCell,
                                                       for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
        let cellModel = HardcodedStorage.shared.sections[indexPath.section].conversations[indexPath.row]
        cell.configure(with: cellModel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedModel = HardcodedStorage.shared.sections[indexPath.section].conversations[indexPath.row]
        let conversationViewController = ConversationViewController(with: selectedModel)
        navigationController?.pushViewController(conversationViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor        = ThemesManager.shared.textColor
        header.contentView.backgroundColor = ThemesManager.shared.mainBGColor.withAlphaComponent(0.8)
    }
}

// Delegate method
extension ConversationsListViewController: ThemesPickerDelegate {
    func updateColors() {
        applyNewTheme()
    }
}
