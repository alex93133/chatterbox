import UIKit

class ConversationsListViewController: UIViewController {

    // MARK: - Properties
    private lazy var conversationsListView: ConversationsListView = {
        let view = ConversationsListView(frame: UIScreen.main.bounds)
        return view
    }()

    // MARK: - VC Lifecycle
    override func loadView() {
        view = conversationsListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }

    // MARK: - Functions
    private func setupView() {
        conversationsListView.setupUIElements()
        conversationsListView.backgroundColor      = ThemesManager.shared.mainBGColor
        conversationsListView.tableView.delegate   = self
        conversationsListView.tableView.dataSource = self
        conversationsListView.tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: Identifiers.conversationCell)
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

        let image = UserManager.shared.userModel.accountIcon
        let accountButton = UIBarButtonItem.roundedButton(from: image,
                                                          target: self,
                                                          action: #selector(accountItemPressed))
        navigationItem.rightBarButtonItem = accountButton
    }

    // MARK: - Actions
    @objc
    private func settingsItemPressed() {
        let theme                     = UserManager.shared.userModel.theme
        let themesViewController      = ThemesViewController(with: theme)
        themesViewController.delegate = self
        navigationController?.pushViewController(themesViewController, animated: true)
    }

    @objc
    private func accountItemPressed() {
        let profileModel               = UserManager.shared.userModel
        let profileViewController      = ProfileViewController(with: profileModel)
        let navigationController       = UINavigationController(rootViewController: profileViewController)
        present(navigationController, animated: true)
        profileViewController.updateUserIcon = { [weak self] in
            guard let self = self else { return }
            let image = UserManager.shared.userModel.accountIcon
            let accountButton = UIBarButtonItem.roundedButton(from: image,
                                                              target: self,
                                                              action: #selector(self.accountItemPressed))
            self.navigationItem.rightBarButtonItem = accountButton
        }
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

// Delegates
extension ConversationsListViewController: ThemesPickerDelegate {
    func updateColors() {
        conversationsListView.tableView.backgroundColor = ThemesManager.shared.mainBGColor
        conversationsListView.backgroundColor           = ThemesManager.shared.mainBGColor
        navigationItem.leftBarButtonItem?.tintColor     = ThemesManager.shared.barItemColor
        conversationsListView.tableView.reloadData()
        guard let cells = conversationsListView.tableView.visibleCells as? [ConversationTableViewCell] else { return }
        cells.forEach { $0.nameLabel.textColor = ThemesManager.shared.textColor }
    }
}
