import UIKit

class ConversationView: UIView {

    // MARK: - UI
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemesService.shared.mainBGColor
        return tableView
    }()

    lazy var inputBarView = InputBarView()

    func setupUIElements() {
        addSubviews(tableView, inputBarView)
        setupTableViewConstraints()
        setupInputBarViewConstraints()
    }

    // MARK: - Constraints
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputBarView.topAnchor)
        ])
    }

    private func setupInputBarViewConstraints() {
        inputBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputBarView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            inputBarView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            inputBarView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
