import UIKit

class ConversationsListView: UIView {

    // MARK: - UI
    lazy var tableView: UITableView = {
        let tableView             = UITableView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight       = 88
        tableView.backgroundColor = ThemesManager.shared.mainBGColor
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: Identifiers.conversationCell)
        return tableView
    }()

    func setupUIElements() {
        addSubviews(tableView)
        setupTableViewConstraints()
    }

    // MARK: - Constraints
    private func setupTableViewConstraints() {
        addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
