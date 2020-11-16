import UIKit
import CoreData

class ConversationsListViewController: UIViewController {

    // MARK: - Properties
    private lazy var conversationsListView: ConversationsListView = {
        let view = ConversationsListView(frame: UIScreen.main.bounds)
        return view
    }()

    private lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let context = CoreDataManager.shared.coreDataStack.container.viewContext
        let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let nilMessageDescriptor = NilsLastSortDescriptor(key: "lastMessage", ascending: false)
        let dateDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [dateDescriptor, nilMessageDescriptor]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: "channelsCache")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

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
        FirebaseManager.shared.getChannels()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Logger.shared.printLogs(text: "FRC error: \(error.localizedDescription)")
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
                                                placeholder: NSLocalizedString("Channel name", comment: "")) { text in
            FirebaseManager.shared.createChannel(name: text)
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
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.conversationCell,
                                                    for: indexPath) as? ConversationTableViewCell {
            let channelDB = fetchedResultsController.object(at: indexPath)
            let cellModel = ConversationCellModel(channel: channelDB)
            cell.configure(with: cellModel)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channelDB = fetchedResultsController.object(at: indexPath)
        let conversationViewController = ConversationViewController(with: channelDB)
        navigationController?.pushViewController(conversationViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = ThemesManager.shared.textColor
        header.contentView.backgroundColor = ThemesManager.shared.mainBGColor.withAlphaComponent(0.8)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete", comment: "")) { [weak self] (_, indexPath) in
            guard let self = self else { return }
            let channelDB = self.fetchedResultsController.object(at: indexPath)
            if let identifier = channelDB.identifier {
                FirebaseManager.shared.deleteChannel(identifier: identifier)
            }
        }
        return [deleteAction]
    }
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationsListView.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                conversationsListView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

        case .update:
            if let indexPath = indexPath,
               let cell = conversationsListView.tableView.cellForRow(at: indexPath) as? ConversationTableViewCell {
                let channelDB = fetchedResultsController.object(at: indexPath)
                let cellModel = ConversationCellModel(channel: channelDB)
                cell.configure(with: cellModel)
            }

        case .move:
            if let indexPath = indexPath {
                conversationsListView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                conversationsListView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

        case .delete:
            if let indexPath = indexPath {
                conversationsListView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }

        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationsListView.tableView.endUpdates()
    }
}

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
