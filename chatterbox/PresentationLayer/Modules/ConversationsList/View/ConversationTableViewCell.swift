import UIKit

class ConversationTableViewCell: UITableViewCell, ConfigurableView {

    typealias ConfigurationModel = ConversationCellModel

    // MARK: - UI
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor = themesService.textColor
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.9
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return nameLabel
    }()

    lazy var lastMessageLabel: UILabel = {
        let lastMessageLabel = UILabel()
        lastMessageLabel.font = .systemFont(ofSize: 15, weight: .regular)
        lastMessageLabel.textColor = UIColor(hex: "#8D8D93")
        return lastMessageLabel
    }()

    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 15, weight: .regular)
        dateLabel.textColor = UIColor(hex: "#8D8D93")
        dateLabel.textAlignment = .right
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return dateLabel
    }()
    
    // MARK: - Dependencies
       var themesService: ThemesServiceProtocol!
       
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIElements()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setDefaultCellProperties()
    }

    private func setupUIElements() {
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        backgroundColor = .clear
        addSubviews(nameLabel, lastMessageLabel, dateLabel)
        setupNameLabelConstraints()
        setupLastMessageLabelConstraints()
        setupDateLabelConstraints()
    }

    func configure(with model: ConfigurationModel) {
        nameLabel.text = model.channel.name
        lastMessageLabel.text = model.channel.lastMessage

        if let dateString = model.dateString {
            dateLabel.text = dateString
        }

        if model.channel.lastMessage == nil {
            lastMessageLabel.text = NSLocalizedString("No messages yet", comment: "")
            lastMessageLabel.font = .italicSystemFont(ofSize: 15)
            dateLabel.isHidden = true
        }
    }

    private func setDefaultCellProperties() {
        lastMessageLabel.font = .systemFont(ofSize: 15, weight: .regular)
        dateLabel.isHidden = false
    }

    // MARK: - Constraints
    private func setupNameLabelConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupLastMessageLabelConstraints() {
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastMessageLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            lastMessageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            lastMessageLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -36),
            lastMessageLabel.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func setupDateLabelConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: lastMessageLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
