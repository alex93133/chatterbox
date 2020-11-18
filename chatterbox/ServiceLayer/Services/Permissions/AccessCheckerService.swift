import Photos
import UIKit

protocol AccessCheckerServiceProtocol {
    func checkCameraAccess(target: UIViewController, handler: @escaping (AccessResult) -> Void)
}

struct AccessCheckerService: AccessCheckerServiceProtocol {

    func checkCameraAccess(target: UIViewController, handler: @escaping (AccessResult) -> Void) {
        let statusOfCamera = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

        if statusOfCamera == .notDetermined {
            presentViewWithWarning(target: target) { success -> Void in
                if success {
                    handler(.request)
                }
            }
        }

        if statusOfCamera == .authorized {
            handler(.allow)
        }
        if statusOfCamera == .denied {
            handler(.error)
            presentViewWithError(target: target)
        }
    }

    private func presentViewWithError(target: UIViewController) {
        let alertMessage = NSLocalizedString("""
                                             Looks like you forgot to turn on the camera access. To continue, you'll need to fix it in the Settings
                                             """, comment: "")

        let alert = UIAlertController(title: NSLocalizedString("Oops!", comment: ""),
                                      message: alertMessage,
                                      preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Maybe later", comment: ""), style: .cancel)
        let openSettingsAction = UIAlertAction(title: NSLocalizedString("Open Settings", comment: ""), style: .default) { _ in
            self.openSettings()
        }

        alert.addAction(cancelAction)
        alert.addAction(openSettingsAction)

        target.present(alert, animated: true)
    }

    private func presentViewWithWarning(target: UIViewController, response: @escaping (Bool) -> Void) {
        let alertMessage = NSLocalizedString("For the full application, you will need a smartphone camera. Please allow access", comment: "")

        let alert = UIAlertController(title: NSLocalizedString("Please note", comment: ""),
                                      message: alertMessage,
                                      preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Maybe later", comment: ""), style: .cancel) { _ in
            response(false)
        }
        let getAccessAction = UIAlertAction(title: NSLocalizedString("Get access", comment: ""), style: .default) { _ in
            response(true)
        }

        alert.addAction(cancelAction)
        alert.addAction(getAccessAction)

        target.present(alert, animated: true)
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
