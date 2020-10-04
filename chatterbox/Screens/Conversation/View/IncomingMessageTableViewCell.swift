import UIKit

class IncomingMessageTableViewCell: UITableViewCell, ConfigurableView {

    typealias ConfigurationModel = MessageCellModel

    // MARK: - UI
    private lazy var overlayView: UIView = {
        let overlayView                = UIView()
        overlayView.backgroundColor    = ThemesManager.shared.incomingMessageBGColor
        overlayView.layer.cornerRadius = 8
        return overlayView
    }()

    lazy var incomingMessageLabel: UILabel = {
        let incomingMessageLabel           = UILabel()
        incomingMessageLabel.font          = .systemFont(ofSize: 16, weight: .regular)
        incomingMessageLabel.textColor     = ThemesManager.shared.textColor
        incomingMessageLabel.numberOfLines = 0
        return incomingMessageLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIElements()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with model: MessageCellModel) {
        incomingMessageLabel.text = model.text
    }

    private func setupUIElements() {
        selectionStyle  = .none
        backgroundColor = .clear
        addSubviews(overlayView, incomingMessageLabel)
        setupOverlayViewConstraints()
        setupIncomingMessageLabelConstraints()
    }

    // MARK: - Constraints
    private func setupOverlayViewConstraints() {
        addSubview(overlayView)

        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            overlayView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            overlayView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            overlayView.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 3 / 4)
        ])
    }

    private func setupIncomingMessageLabelConstraints() {
        overlayView.addSubview(incomingMessageLabel)

        incomingMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomingMessageLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            incomingMessageLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -8),
            incomingMessageLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 5),
            incomingMessageLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -5)
        ])
    }
}
