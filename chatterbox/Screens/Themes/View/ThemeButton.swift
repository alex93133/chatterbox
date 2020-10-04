import UIKit

class ThemeButton: UIButton {

    override var isSelected: Bool {
        willSet (selected) {
            let color = selected ? UIColor.systemBlue : UIColor(hex: "#979797")
            let borderWidth: CGFloat = selected ? 3 : 1
            imageView?.layer.borderColor = color.cgColor
            imageView?.layer.borderWidth = borderWidth
        }
    }

    convenience init(title: String, image: UIImage) {
        self.init(frame: .zero)
        guard let imageView = imageView else { return }
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(ThemesManager.shared.textColor, for: .normal)

        imageView.layer.cornerRadius = 14
        titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)

        replaceButtonLabel()
    }

    // MARK: - Functions
    private func replaceButtonLabel() {
        guard let image = imageView?.image else { return }
        let spacing: CGFloat = 20
        let width: CGFloat   = image.size.width
        let height: CGFloat  = image.size.height
        titleEdgeInsets = UIEdgeInsets(top: height + spacing,
                                       left: -width,
                                       bottom: -height,
                                       right: 0)
    }

    func setupBasicConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 300),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            heightAnchor.constraint(equalToConstant: 57)
        ])
    }
}
