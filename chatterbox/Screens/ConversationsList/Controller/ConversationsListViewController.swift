import UIKit

class ConversationsListViewController: UIViewController {

    // MARK: - Properties
    private lazy var conversationsListView: ConversationsListView = {
        let view = ConversationsListView(frame: UIScreen.main.bounds)
        return view
    }()

    private var manager = FirebaseManager()
    private var cellModels = [ConversationCellModel]() {
        didSet {
            conversationsListView.tableView.reloadData()
        }
    }

    // MARK: - VC Lifecycle
    override func loadView() {
        view = conversationsListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        getData()
    }

    // MARK: - Functions
    private func setupView() {
        conversationsListView.setupUIElements()
        conversationsListView.backgroundColor = ThemesManager.shared.mainBGColor
        conversationsListView.tableView.delegate = self
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

        let createChannelAction = UIBarButtonItem(barButtonSystemItem: .add,
                                                  target: self,
                                                  action: #selector(createChannel))

        let image = UserManager.shared.userModel.accountIcon
        let accountButton = UIBarButtonItem.roundedButton(from: image,
                                                          target: self,
                                                          action: #selector(accountItemPressed))
        navigationItem.rightBarButtonItems = [accountButton, createChannelAction]
    }

    private func getData() {
        manager.getChannels { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let channels):
                var models = channels.map { ConversationCellModel(channel: $0) }
                models.sort { $0.channel.lastActivity ?? .distantPast > $1.channel.lastActivity ?? .distantPast }
                self.cellModels = models

            case .failure(let error):
                Logger.shared.printLogs(text: "Unable to get data from Firebase. Error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Actions
    @objc
    private func settingsItemPressed() {
        let theme = UserManager.shared.userModel.theme
        let themesViewController = ThemesViewController(with: theme)
        themesViewController.delegate = self
        navigationController?.pushViewController(themesViewController, animated: true)
    }

    @objc
    private func createChannel() {
        let alertController = UIAlertController(title: NSLocalizedString("Create a new channel", comment: ""),
                                                placeholder: NSLocalizedString("Channel name", comment: "")) { [weak self] text in
                                                    guard let self = self else { return }
                                                    self.manager.createChannel(name: text)
        }
        present(alertController, animated: true, completion: nil)
    }

    @objc
    private func accountItemPressed() {
        let profileModel = UserManager.shared.userModel
        let profileViewController = ProfileViewController(with: profileModel)
        let navigationController = UINavigationController(rootViewController: profileViewController)
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

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Channels", comment: "")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.conversationCell,
                                                       for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
        let cellModel = cellModels[indexPath.row]
        cell.configure(with: cellModel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedModel = cellModels[indexPath.row]
        let conversationViewController = ConversationViewController(with: selectedModel.channel)
        navigationController?.pushViewController(conversationViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = ThemesManager.shared.textColor
        header.contentView.backgroundColor = ThemesManager.shared.mainBGColor.withAlphaComponent(0.8)
    }
}

// Delegates
extension ConversationsListViewController: ThemesPickerDelegate {
    func updateColors() {
        conversationsListView.tableView.backgroundColor = ThemesManager.shared.mainBGColor
        conversationsListView.backgroundColor = ThemesManager.shared.mainBGColor
        navigationItem.leftBarButtonItem?.tintColor = ThemesManager.shared.barItemColor
        conversationsListView.tableView.reloadData()
        guard let cells = conversationsListView.tableView.visibleCells as? [ConversationTableViewCell] else { return }
        cells.forEach { $0.nameLabel.textColor = ThemesManager.shared.textColor }
    }
}
