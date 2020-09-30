import UIKit

class ConversationViewController: UIViewController, ConfigurableView {

    // MARK: - Properties
    private let customView = ConversationView(frame: UIScreen.main.bounds)
    var conversationModel: ConversationCellModel
    var cellModels: [MessageCellModel]?

    typealias ConfigurationModel = ConversationCellModel

    init(with conversationModel: ConversationCellModel) {
        self.conversationModel = conversationModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure(with: conversationModel)
        getData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollTableViewToLast()
    }

    // MARK: - Functions
    private func setupView() {
        customView.setupUIElements()
        view                            = customView
        customView.backgroundColor      = Colors.mainBG
        customView.tableView.delegate   = self
        customView.tableView.dataSource = self
    }

    func configure(with model: ConfigurationModel) {
        let title            = "\(model.name) (\(model.statusString))"
        navigationItem.title = title
    }

    private func getData() {
        cellModels = HardcodedStorage.shared.getCellModels(finalMessage: conversationModel.message)
    }

    private func scrollTableViewToLast() {
        guard let cellModels = cellModels, !conversationModel.message.isEmpty else { return }
        DispatchQueue.main.async {
            let lastIndexPath = IndexPath(row: cellModels.count - 1, section: 0)
            self.customView.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
        }
    }
}

// MARK: - Delegates
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cellModels = cellModels, !conversationModel.message.isEmpty else { return 0 }
        return cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let incomingCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.incomingMessageCell,
                                                               for: indexPath) as? IncomingMessageTableViewCell else { return UITableViewCell() }

        guard let outGoingCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.outgoingMessageCell,
                                                               for: indexPath) as? OutgoingMessageTableViewCell else { return UITableViewCell() }

        guard let cellModels = cellModels else { return UITableViewCell() }
        let cellModel = cellModels[indexPath.row]

        if cellModel.isIncoming {
            incomingCell.configure(with: cellModel)
            return incomingCell
        } else {
            outGoingCell.configure(with: cellModel)
            return outGoingCell
        }
    }
}
