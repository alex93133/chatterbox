import UIKit

class ConversationViewController: UIViewController, ConfigurableView {

    // MARK: - Properties
    private lazy var conversationView: ConversationView = {
        let view = ConversationView(frame: UIScreen.main.bounds)
        return view
    }()
    private var channelModel: Channel
    private let manager = FirebaseManager()
    private var cellModels = [MessageCellModel]() {
        didSet {
            conversationView.tableView.reloadData()
            scrollTableViewToLast()
        }
    }

    typealias ConfigurationModel = Channel

    init(with channelModel: Channel) {
        self.channelModel = channelModel
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
        setupNavigationBar()
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
    }

    private func setupNavigationBar() {
        let send = UIBarButtonItem(barButtonSystemItem: .add,
                                   target: self,
                                   action: #selector(sendMessage))
        navigationItem.rightBarButtonItem = send
    }

    func configure(with model: ConfigurationModel) {
        let title = model.name
        navigationItem.title = title
    }

    private func setTextViewPlaceHolder() {
        conversationView.inputBarView.inputTextView.text = NSLocalizedString("Send message", comment: "")
        conversationView.inputBarView.inputTextView.textColor = UIColor.lightGray
    }

    private func getData() {
        manager.getMessages(identifier: channelModel.identifier) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                let models = messages.map { message -> MessageCellModel in
                    let isIncoming = UserManager.shared.userModel.uuID == message.senderId ? false : true
                    return MessageCellModel(message: message, isIncoming: isIncoming)
                }
                self.cellModels = models.sorted { $0.message.created < $1.message.created }

            case .failure(let error):
                Logger.shared.printLogs(text: "Unable to get data from Firebase. Error: \(error.localizedDescription)")
            }
        }
    }

    private func scrollTableViewToLast() {
        guard !cellModels.isEmpty else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let lastIndexPath = IndexPath(row: self.cellModels.count - 1, section: 0)
            self.conversationView.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
        }
    }

    // MARK: - Actions
    @objc
    private func sendMessage() {
        let textView = conversationView.inputBarView.inputTextView
        guard let text = textView.text,
            !text.isEmpty else { return }
        //        manager.sendMessage(content: text, identifier: channelModel.identifier)
        textView.text = ""
        setTextViewPlaceHolder()
        view.endEditing(true)
    }
}

// MARK: - Delegates
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = cellModels[indexPath.row]

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

extension ConversationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = ThemesManager.shared.textColor
        }
    }
}
