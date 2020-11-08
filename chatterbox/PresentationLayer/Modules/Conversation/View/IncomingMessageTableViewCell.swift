import UIKit

class IncomingMessageTableViewCell: UITableViewCell, ConfigurableView {

    typealias ConfigurationModel = MessageCellModel

    // MARK: - UI
    private lazy var overlayView: UIView = {
        let overlayView = UIView()
        overlayView.backgroundColor = themesService.incomingMessageBGColor
        overlayView.layer.cornerRadius = 8
        return overlayView
    }()

    lazy var senderNameLabel: UILabel = {
        let senderNameLabel = UILabel()
        senderNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        senderNameLabel.textColor = .systemBlue
        senderNameLabel.numberOfLines = 0
        return senderNameLabel
    }()

    lazy var incomingMessageLabel: UILabel = {
        let incomingMessageLabel = UILabel()
        incomingMessageLabel.font = .systemFont(ofSize: 16, weight: .regular)
        incomingMessageLabel.textColor = themesService.textColor
        incomingMessageLabel.numberOfLines = 0
        return incomingMessageLabel
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

    func configure(with model: ConfigurationModel) {
        senderNameLabel.text = model.message.senderName
        incomingMessageLabel.text = model.message.content
    }

    private func setupUIElements() {
        selectionStyle = .none
        backgroundColor = .clear
        addSubviews(overlayView, senderNameLabel, incomingMessageLabel)
        setupOverlayViewConstraints()
        setupSenderNameLabelConstraints()
        setupIncomingMessageLabelConstraints()
    }

    // MARK: - Constraints
    private func setupOverlayViewConstraints() {
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            overlayView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            overlayView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            overlayView.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 3 / 4)
        ])
    }

    private func setupSenderNameLabelConstraints() {
        senderNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            senderNameLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 5),
            senderNameLabel.bottomAnchor.constraint(equalTo: incomingMessageLabel.topAnchor, constant: -2),
            senderNameLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            senderNameLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -8)
        ])
    }

    private func setupIncomingMessageLabelConstraints() {
        incomingMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomingMessageLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            incomingMessageLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -8),
            incomingMessageLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -5)
        ])
    }
}
