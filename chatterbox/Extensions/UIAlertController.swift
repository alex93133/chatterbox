import UIKit

extension UIAlertController {
    convenience init(title: String, placeholder: String, actionHandler: @escaping (String) -> Void) {
        self.init(title: title,
                  message: nil,
                  preferredStyle: .alert)

        var textFieldText = ""

        let createAction = UIAlertAction(title: NSLocalizedString("Create", comment: ""),
                                         style: .default) { _ in
            actionHandler(textFieldText)
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel)

        createAction.isEnabled = false

        addTextField { (textField: UITextField) in
            textField.placeholder = placeholder
            textField.autocapitalizationType = .sentences
            _ = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: .main) { _ in
                guard let text = textField.text else { return }
                createAction.isEnabled = !text.isEmpty
                textFieldText = text
            }
        }

        addAction(createAction)
        addAction(cancelAction)
    }

    // This method hides error because of bug with breaking alert controller width constraint since iOS 12.2
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
