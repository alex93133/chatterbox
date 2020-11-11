import UIKit

class OutgoingMessageTableViewCell: UITableViewCell {

    typealias ConfigurationModel = MessageCellModel

    // MARK: - UI
    private lazy var overlayView: UIView = {
        let overlayView = UIView()
        overlayView.layer.cornerRadius = 8
        return overlayView
    }()

    lazy var outgoingMessageLabel: UILabel = {
        let outgoingMessageLabel = UILabel()
        outgoingMessageLabel.font = .systemFont(ofSize: 16, weight: .regular)
        outgoingMessageLabel.numberOfLines = 0
        return outgoingMessageLabel
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
        updateColors()
        outgoingMessageLabel.text = model.message.content
    }
    
    private func updateColors() {
        overlayView.backgroundColor = themesService.outgoingMessageBGColor
        outgoingMessageLabel.textColor = themesService.outgoingMessageTextColor
    }

    private func setupUIElements() {
        selectionStyle = .none
        backgroundColor = .clear
        addSubviews(overlayView, outgoingMessageLabel)
        setupOverlayViewConstraints()
        setupOutgoingMessageLabelConstraints()
    }

    // MARK: - Constraints
    private func setupOverlayViewConstraints() {
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
            overlayView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            overlayView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            overlayView.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 3 / 4)
        ])
    }

    private func setupOutgoingMessageLabelConstraints() {
        outgoingMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            outgoingMessageLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            outgoingMessageLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -8),
            outgoingMessageLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 5),
            outgoingMessageLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -5)
        ])
    }
}
