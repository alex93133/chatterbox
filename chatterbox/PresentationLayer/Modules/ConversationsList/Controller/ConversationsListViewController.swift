import UIKit
import CoreData

class ConversationsListViewController: UIViewController {

    // MARK: - Properties
    lazy var conversationsListView: ConversationsListView = {
        let view = ConversationsListView(frame: UIScreen.main.bounds)
        return view
    }()

    lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let context = CoreDataService.shared.coreDataStack.container.viewContext
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
        conversationsListView.backgroundColor = ThemesService.shared.mainBGColor
        conversationsListView.tableView.delegate = self
        conversationsListView.tableView.dataSource = self
        conversationsListView.tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: Identifiers.conversationCell)
    }

    private func setupNavigationBar() {
        ThemesService.shared.setupNavigationBar(target: self)
        navigationItem.title = "Tinkoff Chat"
        let settingsUIBarButtonItem = UIBarButtonItem(image: Images.settings,
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(settingsItemPressed))
        settingsUIBarButtonItem.tintColor = ThemesService.shared.barItemColor
        navigationItem.leftBarButtonItem = settingsUIBarButtonItem

        let createChannelAction = UIBarButtonItem(barButtonSystemItem: .add,
                                                  target: self,
                                                  action: #selector(createChannel))

        let image = UserDataService.shared.userModel.accountIcon
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
            LoggerService.shared.printLogs(text: "FRC error: \(error.localizedDescription)")
        }
    }

    // MARK: - Actions
    @objc
    private func settingsItemPressed() {
        let theme = UserDataService.shared.userModel.theme
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
        let profileModel = UserDataService.shared.userModel
        let profileViewController = ProfileViewController(with: profileModel)
        let navigationController = UINavigationController(rootViewController: profileViewController)
        present(navigationController, animated: true)
        profileViewController.updateUserIcon = { [weak self] in
            guard let self = self else { return }
            let image = UserDataService.shared.userModel.accountIcon
            let accountButton = UIBarButtonItem.roundedButton(from: image,
                                                              target: self,
                                                              action: #selector(self.accountItemPressed))
            self.navigationItem.rightBarButtonItem = accountButton
        }
    }
}
