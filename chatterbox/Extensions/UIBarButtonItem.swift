import UIKit

extension UIBarButtonItem {
    class func roundedButton(from image: UIImage, target: Any, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.layer.cornerRadius = button.frame.width / 2
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setImage(image, for: .normal)

        let customBarButton = UIBarButtonItem(customView: button)
        customBarButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        customBarButton.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        customBarButton.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true

        return customBarButton
    }
}
