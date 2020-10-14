import UIKit

class SaveButton: UIButton {

    override var isEnabled: Bool {
        willSet {
            let alphaValue: CGFloat = newValue ? 1 : 0.5
            UIView.animate(withDuration: 0.3) {
                self.alpha = alphaValue
            }
        }
    }

    convenience init(title: String) {
        self.init(frame: .zero)
        titleLabel?.font   = UIFont.systemFont(ofSize: 19, weight: .semibold)
        backgroundColor    = UIColor.systemGray.withAlphaComponent(0.2)
        layer.cornerRadius = 14
        setTitleColor(UIColor.systemBlue, for: .normal)
        setTitle(title, for: .normal)
    }
}
