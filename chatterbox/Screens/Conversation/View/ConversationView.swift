import UIKit

class ConversationView: UIView {

    // MARK: - UI
    lazy var tableView: UITableView = {
        let tableView             = UITableView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight       = UITableView.automaticDimension
        tableView.separatorStyle  = .none
        tableView.backgroundColor = ThemesManager.shared.mainBGColor
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
