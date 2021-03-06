import UIKit
import CoreData

class ConversationViewController: UIViewController, ConfigurableView {

    // MARK: - Properties
    lazy var conversationView: ConversationView = {
        let view = ConversationView(themesService: model.themesService)
        return view
    }()

    lazy var logoEmitter: LogoEmitterAnimation = {
        let logoEmitter = LogoEmitterAnimation(target: conversationView)
        return logoEmitter
    }()

    private var channelModel: ChannelDB
    private var identifier: String

    lazy var fetchedResultsController: NSFetchedResultsController<MessageDB> = {
        let fetchRequest: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        let predicate = NSPredicate(format: "channel.identifier == %@", identifier)
        let dateDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [dateDescriptor]
        fetchRequest.predicate = predicate

        let fetchedResultsController = model.frcService.getFRC(fetchRequest: fetchRequest,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: "messageCache\(identifier)")

        return fetchedResultsController
    }()

    typealias ConfigurationModel = ChannelDB

    // MARK: - Dependencies
    var model: ConversationModelProtocol
    var presentationAssembly: PresentationAssemblyProtocol

    init(model: ConversationModelProtocol, presentationAssembly: PresentationAssemblyProtocol) {
        self.model = model
        self.channelModel = model.channelModel
        self.identifier = model.channelModel.identifier ?? ""
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Lifecycle
    override func loadView() {
        view = conversationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure(with: channelModel)
        setTextViewPlaceHolder()
        getData()
        hideKeyboardWhenTappedOutside()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObserver()
    }

    // MARK: - Functions
    private func setupView() {
        conversationView.setupUIElements()
        conversationView.backgroundColor = model.themesService.barColor
        conversationView.tableView.delegate = self
        conversationView.tableView.dataSource = self
        conversationView.inputBarView.inputTextView.delegate = self
        conversationView.tableView.register(IncomingMessageTableViewCell.self, forCellReuseIdentifier: Identifiers.incomingMessageCell)
        conversationView.tableView.register(OutgoingMessageTableViewCell.self, forCellReuseIdentifier: Identifiers.outgoingMessageCell)
        conversationView.inputBarView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        fetchedResultsController.delegate = self
        logoEmitter.addLogoEmitter()
    }

    func configure(with model: ConfigurationModel) {
        let title = model.name
        navigationItem.title = title
    }

    func setTextViewPlaceHolder() {
        conversationView.inputBarView.inputTextView.text = NSLocalizedString("Message text", comment: "")
        conversationView.inputBarView.inputTextView.textColor = UIColor.lightGray
    }

    private func getData() {
        model.chatDataService.getMessages(identifier: identifier)
        do {
            try fetchedResultsController.performFetch()
            scrollTableViewToLast()
        } catch {
            Logger.shared.printLogs(text: "FRC error: \(error.localizedDescription)")
        }
    }

    func scrollTableViewToLast() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let messagesCount = self.fetchedResultsController.fetchedObjects?.count,
                  messagesCount > 0 else { return }

            let lastIndexPath = IndexPath(row: messagesCount - 1, section: 0)
            self.conversationView.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
        }
    }

    func adjustTextViewHeight() {
        let maxHeight: CGFloat = view.frame.height / 4
        let textView = conversationView.inputBarView.inputTextView

        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height >= maxHeight {
            textView.isScrollEnabled = true
            conversationView.inputBarView.textViewHeightConstraint.constant = maxHeight
        } else {
            textView.isScrollEnabled = false
            conversationView.inputBarView.textViewHeightConstraint.constant = newSize.height
        }
        view.layoutIfNeeded()
    }

    // MARK: - Actions
    @objc
    private func sendMessage() {
        let textView = conversationView.inputBarView.inputTextView
        guard let text = textView.text,
              !text.isEmpty,
              textView.textColor != UIColor.lightGray else { return }
        model.chatDataService.sendMessage(content: text, identifier: identifier)
        textView.text = ""
        adjustTextViewHeight()
    }
}
