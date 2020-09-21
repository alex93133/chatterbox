import UIKit

extension UIAlertController {
    // This method hides error because of bug with breaking alert controller width constraint since iOS 12.2
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
