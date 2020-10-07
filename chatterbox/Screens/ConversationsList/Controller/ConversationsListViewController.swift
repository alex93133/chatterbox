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
        customView.backgroundColor      = Colors.mainBG
        customView.tableView.delegate   = self
        customView.tableView.dataSource = self
    }

    private func setupNavigationBar() {
        navigationItem.title = "Tinkoff Chat"
        let settingsUIBarButtonItem = UIBarButtonItem(image: Images.settings,
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(settingsItemPressed))
        settingsUIBarButtonItem.tintColor = Colors.gray
        navigationItem.leftBarButtonItem = settingsUIBarButtonItem

        let image = UserManager.shared.currentUserModel.accountIcon
        let accountButton = UIBarButtonItem.roundedButton(from: image,
                                                          target: self,
                                                          action: #selector(accountItemPressed))
        navigationItem.rightBarButtonItem = accountButton
    }

    // MARK: - Actions
    @objc
    private func settingsItemPressed() {
        print("Settings action")
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
}
