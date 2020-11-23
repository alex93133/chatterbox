import UIKit

class ConversationsListView: UIView {

    // MARK: - UI
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 88
        tableView.backgroundColor = themesService.mainBGColor
        return tableView
    }()

    // MARK: - Dependencies
    var themesService: ThemesServiceProtocol

    init(themesService: ThemesServiceProtocol) {
        self.themesService = themesService
        super.init(frame: UIScreen.main.bounds)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUIElements() {
        addSubviews(tableView)
        setupTableViewConstraints()
    }

    // MARK: - Constraints
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
