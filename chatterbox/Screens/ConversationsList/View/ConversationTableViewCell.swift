import UIKit

class ConversationTableViewCell: UITableViewCell, ConfigurableView {

    typealias ConfigurationModel = ConversationCellModel

    // MARK: - UI
    lazy var nameLabel: UILabel = {
        let nameLabel                       = UILabel()
        nameLabel.font                      = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor                 = ThemesManager.shared.textColor
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor        = 0.9
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return nameLabel
    }()

    lazy var lastMessageLabel: UILabel = {
        let lastMessageLabel       = UILabel()
        lastMessageLabel.font      = .systemFont(ofSize: 15, weight: .regular)
        lastMessageLabel.textColor = UIColor(hex: "#8D8D93")
        return lastMessageLabel
    }()

    lazy var photoImageView: UIImageView = {
        let photoImageView                = UIImageView()
        photoImageView.contentMode        = .scaleAspectFill
        photoImageView.layer.cornerRadius = 24
        photoImageView.clipsToBounds      = true
        photoImageView.backgroundColor    = .red
        return photoImageView
    }()

    lazy var dateLabel: UILabel = {
        let dateLabel           = UILabel()
        dateLabel.font          = .systemFont(ofSize: 15, weight: .regular)
        dateLabel.textColor     = UIColor(hex: "#8D8D93")
        dateLabel.textAlignment = .right
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return dateLabel
    }()

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
        accessoryType   = .disclosureIndicator
        selectionStyle  = .none
        backgroundColor = .clear
        addSubviews(nameLabel, lastMessageLabel, photoImageView, dateLabel)
        setupNameLabelConstraints()
        setupLastMessageLabelConstraints()
        setupPhotoImageViewConstraints()
        setupDateLabelConstraints()
    }

    func configure(with model: ConfigurationModel) {
        nameLabel.text        = model.name
        lastMessageLabel.text = model.message
        dateLabel.text        = model.dateString

        if model.hasUnreadMessages {
            lastMessageLabel.font = .systemFont(ofSize: 15, weight: .bold)
        }

        if model.message.isEmpty {
            lastMessageLabel.text = NSLocalizedString("No messages yet", comment: "")
            lastMessageLabel.font = .italicSystemFont(ofSize: 15)
            dateLabel.isHidden    = true
        }
    }

    private func setDefaultCellProperties() {
        lastMessageLabel.font = .systemFont(ofSize: 15, weight: .regular)
        dateLabel.isHidden    = false
    }

    // MARK: - Constraints
    private func setupNameLabelConstraints() {
        addSubview(nameLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 76),
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupLastMessageLabelConstraints() {
        addSubview(lastMessageLabel)

        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastMessageLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 76),
            lastMessageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            lastMessageLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -36),
            lastMessageLabel.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func setupPhotoImageViewConstraints() {
        addSubview(photoImageView)

        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.heightAnchor.constraint(equalToConstant: 48),
            photoImageView.widthAnchor.constraint(equalToConstant: 48),
            photoImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            photoImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    private func setupDateLabelConstraints() {
        addSubview(dateLabel)

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: lastMessageLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
