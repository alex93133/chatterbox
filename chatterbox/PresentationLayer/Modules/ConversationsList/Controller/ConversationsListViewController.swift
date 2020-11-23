import UIKit
import CoreData

class ConversationsListViewController: UIViewController {

    // MARK: - Properties
    lazy var conversationsListView: ConversationsListView = {
        let view = ConversationsListView(themesService: model.themesService)
        return view
    }()

    lazy var logoEmitter: LogoEmitterAnimation = {
        let logoEmitter = LogoEmitterAnimation(target: conversationsListView)
        return logoEmitter
    }()

    lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
        let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        let nilMessageDescriptor = NilsLastSortDescriptor(key: "lastMessage", ascending: false)
        let dateDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [dateDescriptor, nilMessageDescriptor]
        let fetchedResultsController = model.frcService.getFRC(fetchRequest: fetchRequest,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: "channelsCache")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    // MARK: - Dependencies
    var model: ConversationsListModelProtocol
    var presentationAssembly: PresentationAssemblyProtocol

    init(model: ConversationsListModelProtocol, presentationAssembly: PresentationAssemblyProtocol) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        conversationsListView.backgroundColor = model.themesService.mainBGColor
        conversationsListView.tableView.delegate = self
        conversationsListView.tableView.dataSource = self
        conversationsListView.tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: Identifiers.conversationCell)
        logoEmitter.addLogoEmitter()
    }

    private func setupNavigationBar() {
        model.themesService.setupNavigationBar(target: self)
        navigationItem.title = "Tinkoff Chat"
        let settingsUIBarButtonItem = UIBarButtonItem(image: Images.settings,
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(settingsItemPressed))
        settingsUIBarButtonItem.tintColor = model.themesService.barItemColor
        navigationItem.leftBarButtonItem = settingsUIBarButtonItem

        let createChannelAction = UIBarButtonItem(barButtonSystemItem: .add,
                                                  target: self,
                                                  action: #selector(createChannel))

        let image = model.userDataService.userModel.accountIcon
        let accountButton = UIBarButtonItem.roundedButton(from: image,
                                                          target: self,
                                                          action: #selector(accountItemPressed))
        navigationItem.rightBarButtonItems = [accountButton, createChannelAction]
    }

    private func getData() {
        model.chatDataService.getChannels()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            Logger.shared.printLogs(text: "FRC error: \(error.localizedDescription)")
        }
    }

    // MARK: - Actions
    @objc
    private func settingsItemPressed() {
        let theme = model.userDataService.userModel.theme
        let themesViewController = presentationAssembly.themesViewController(with: theme)
        themesViewController.delegate = self
        navigationController?.pushViewController(themesViewController, animated: true)
    }

    @objc
    private func createChannel() {
        let alertController = UIAlertController(title: NSLocalizedString("Create a new channel", comment: ""),
                                                placeholder: NSLocalizedString("Channel name", comment: "")) { [weak self] text in
            guard let self = self else { return }
            self.model.chatDataService.createChannel(name: text)
        }
        present(alertController, animated: true, completion: nil)
    }

    @objc
    private func accountItemPressed() {
        let profile = model.userDataService.userModel
        let profileViewController = presentationAssembly.profileViewController(with: profile)
        profileViewController.updateUserIcon = { [weak self] in
            guard let self = self else { return }
            let image = self.model.userDataService.userModel.accountIcon
            let accountButton = UIBarButtonItem.roundedButton(from: image,
                                                              target: self,
                                                              action: #selector(self.accountItemPressed))
            self.navigationItem.rightBarButtonItem = accountButton
        }

        let navigationController = UINavigationController(rootViewController: profileViewController)
        navigationController.transitioningDelegate = self
        navigationController.modalPresentationStyle = .custom

        present(navigationController, animated: true)
    }
}
