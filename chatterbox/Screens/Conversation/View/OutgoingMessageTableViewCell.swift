import UIKit

class OutgoingMessageTableViewCell: UITableViewCell {

    typealias ConfigurationModel = MessageCellModel

    // MARK: - UI
    private lazy var overlayView: UIView = {
        let overlayView                = UIView()
        overlayView.backgroundColor    = ThemesManager.shared.outgoingMessageBGColor
        overlayView.layer.cornerRadius = 8
        return overlayView
    }()

    lazy var outgoingMessageLabel: UILabel = {
        let outgoingMessageLabel           = UILabel()
        outgoingMessageLabel.font          = .systemFont(ofSize: 16, weight: .regular)
        outgoingMessageLabel.textColor     = ThemesManager.shared.outgoingMessageTextColor
        outgoingMessageLabel.numberOfLines = 0
        return outgoingMessageLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIElements()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(with model: ConfigurationModel) {
        outgoingMessageLabel.text = model.text
    }

    private func setupUIElements() {
        selectionStyle  = .none
        backgroundColor = .clear
        setupOverlayViewConstraints()
        setupOutgoingMessageLabelConstraints()
    }

    // MARK: - Constraints
    private func setupOverlayViewConstraints() {
        addSubview(overlayView)

        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
            overlayView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            overlayView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            overlayView.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 3 / 4)
        ])
    }

    private func setupOutgoingMessageLabelConstraints() {
        overlayView.addSubview(outgoingMessageLabel)

        outgoingMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            outgoingMessageLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            outgoingMessageLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -8),
            outgoingMessageLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 5),
            outgoingMessageLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -5)
        ])
    }
}
