import UIKit
import CoreData

class ConversationViewController: UIViewController, ConfigurableView {

    // MARK: - Properties
    private lazy var conversationView: ConversationView = {
        let view = ConversationView(frame: UIScreen.main.bounds)
        return view
    }()

    private var channelModel: ChannelDB
    private var identifier: String

    private lazy var fetchedResultsController: NSFetchedResultsController<MessageDB> = {
        let context = CoreDataManager.shared.coreDataStack.container.viewContext
        let fetchRequest: NSFetchRequest<MessageDB> = MessageDB.fetchRequest()
        let predicate = NSPredicate(format: "channel.identifier == %@", identifier)
        let dateDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [dateDescriptor]
        fetchRequest.predicate = predicate

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: "messageCache\(identifier)")
        return fetchedResultsController
    }()

    typealias ConfigurationModel = ChannelDB

    init(with channelModel: ChannelDB) {
        self.channelModel = channelModel
        self.identifier = channelModel.identifier ?? ""
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
        conversationView.backgroundColor = ThemesManager.shared.barColor
        conversationView.tableView.delegate = self
        conversationView.tableView.dataSource = self
        conversationView.inputBarView.inputTextView.delegate = self
        conversationView.tableView.register(IncomingMessageTableViewCell.self, forCellReuseIdentifier: Identifiers.incomingMessageCell)
        conversationView.tableView.register(OutgoingMessageTableViewCell.self, forCellReuseIdentifier: Identifiers.outgoingMessageCell)
        conversationView.inputBarView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        fetchedResultsController.delegate = self
    }

    func configure(with model: ConfigurationModel) {
        let title = model.name
        navigationItem.title = title
    }

    private func setTextViewPlaceHolder() {
        conversationView.inputBarView.inputTextView.text = NSLocalizedString("Message text", comment: "")
        conversationView.inputBarView.inputTextView.textColor = UIColor.lightGray
    }

    private func getData() {
        FirebaseManager.shared.getMessages(identifier: identifier)
        do {
            try fetchedResultsController.performFetch()
            scrollTableViewToLast()
        } catch {
            Logger.shared.printLogs(text: "FRC error: \(error.localizedDescription)")
        }
    }

    private func scrollTableViewToLast() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let messagesCount = self.fetchedResultsController.fetchedObjects?.count,
                  messagesCount > 0 else { return }

            let lastIndexPath = IndexPath(row: messagesCount - 1, section: 0)
            self.conversationView.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
        }
    }

    // MARK: - Actions
    @objc
    private func sendMessage() {
        let textView = conversationView.inputBarView.inputTextView
        guard let text = textView.text,
              !text.isEmpty,
              textView.textColor != UIColor.lightGray else { return }
        FirebaseManager.shared.sendMessage(content: text, identifier: identifier)
        textView.text = ""
        adjustTextViewHeight()
    }
}

// MARK: - Delegates
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageDB = fetchedResultsController.object(at: indexPath)
        let cellModel = MessageCellModel(message: messageDB)

        if cellModel.isIncoming {
            if let incomingCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.incomingMessageCell,
                                                                for: indexPath) as? IncomingMessageTableViewCell {
                incomingCell.configure(with: cellModel)
                return incomingCell
            }
        } else {
            if let outGoingCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.outgoingMessageCell,
                                                                for: indexPath) as? OutgoingMessageTableViewCell {
                outGoingCell.configure(with: cellModel)
                return outGoingCell
            }
        }
        return UITableViewCell()
    }
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationView.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                conversationView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

        case .update:
            if let indexPath = indexPath {
                let messageDB = fetchedResultsController.object(at: indexPath)
                let cellModel = MessageCellModel(message: messageDB)
                if cellModel.isIncoming {
                    guard let cell = conversationView.tableView.cellForRow(at: indexPath) as? IncomingMessageTableViewCell else { break }
                    cell.configure(with: cellModel)
                } else {
                    guard let cell = conversationView.tableView.cellForRow(at: indexPath) as? OutgoingMessageTableViewCell else { break }
                    cell.configure(with: cellModel)
                }
            }

        case .move:
            if let indexPath = indexPath {
                conversationView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                conversationView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

        case .delete:
            if let indexPath = indexPath {
                conversationView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }

        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationView.tableView.endUpdates()
        scrollTableViewToLast()
    }
}

extension ConversationViewController: UITextViewDelegate {
    private func adjustTextViewHeight() {
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

    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewHeight()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = ThemesManager.shared.textColor
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setTextViewPlaceHolder()
        }
    }
}
