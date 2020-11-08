import UIKit

class ThemeButton: UIButton {

    // MARK: - UI
    private lazy var themeImageView: UIImageView = {
        let themeImageView = UIImageView()
        themeImageView.contentMode = .scaleAspectFill
        themeImageView.clipsToBounds = true
        themeImageView.backgroundColor = UIColor(hex: "#E4E82B")
        themeImageView.layer.cornerRadius = 14
        return themeImageView
    }()

    lazy var interactiveTitle: UILabel = {
        let interactiveTitle = UILabel()
        interactiveTitle.textColor = ThemesService.shared.outgoingMessageTextColor
        interactiveTitle.font = .systemFont(ofSize: 19, weight: .semibold)
        interactiveTitle.textAlignment = .center
        return interactiveTitle
    }()

    // MARK: - Properties
    override var isSelected: Bool {
        willSet (selected) {
            let color = selected ? UIColor.systemBlue : UIColor(hex: "#979797")
            let borderWidth: CGFloat = selected ? 3 : 1
            themeImageView.layer.borderColor = color.cgColor
            themeImageView.layer.borderWidth = borderWidth
        }
    }

    convenience init(title: String, image: UIImage) {
        self.init(frame: .zero)
        setupUIElements()
        interactiveTitle.text = title
        themeImageView.image = image
    }

    func setupUIElements() {
        addSubviews(themeImageView, interactiveTitle)
        setupThemeImageViewConstraints()
        setupInteractiveTitleConstraints()
    }

    // MARK: - Constraints
    func setupBasicConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 300),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            heightAnchor.constraint(equalToConstant: 96)
        ])
    }

    private func setupThemeImageViewConstraints() {
        themeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            themeImageView.widthAnchor.constraint(equalToConstant: 300),
            themeImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            themeImageView.heightAnchor.constraint(equalToConstant: 57)
        ])
    }

    private func setupInteractiveTitleConstraints() {
        interactiveTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            interactiveTitle.heightAnchor.constraint(equalToConstant: 24),
            interactiveTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            interactiveTitle.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            interactiveTitle.topAnchor.constraint(equalTo: themeImageView.bottomAnchor, constant: 15)
        ])
    }
}
