import UIKit

extension UIImage {
    class func imageWithLabel(_ label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
