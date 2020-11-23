import UIKit

class ConversationView: UIView {

    // MARK: - UI
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = themesService.mainBGColor
        return tableView
    }()

    lazy var inputBarView = InputBarView(themesService: themesService)

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
