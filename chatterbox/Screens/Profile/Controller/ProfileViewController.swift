import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Properties
    private let customView = ProfileView(frame: UIScreen.main.bounds)
    var profilePhoto: UIImage? {
        willSet {
            customView.initialsLabel.isHidden = true
            customView.profilePhotoImageView.image = newValue
        }
    }
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customView.profilePhotoImageView.layer.cornerRadius = customView.profilePhotoImageView.frame.size.width / 2
    }

    // MARK: - Functions
    private func setupView() {
        view = customView
        customView.delegate = self
        if let name = customView.profileNameLabel.text { // Temporarily
            let initials = getInitials(from: name)
            customView.initialsLabel.text = initials
        }
    }

    private func getInitials(from name: String) -> String {
        let namesArray = name.split(separator: " ")
        guard namesArray.count == 2 else { return "" }
        let firstCharacters = namesArray.compactMap { $0.first }
        return String(firstCharacters)
    }

    private func presentRequestPhotoAlert() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)

        let photoLibraryAction = UIAlertAction(title: NSLocalizedString("Photo library", comment: ""), style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presentImagePicker(sourceType: .photoLibrary)
        }

        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { [weak self] _ in
            guard let self = self else { return }
            let accessChecker = AccessChecker()
            accessChecker.checkCameraAccess(target: self) { result in
                guard result != .error else { return }
                self.presentImagePicker(sourceType: .camera)
            }
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)

        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)

        alertController.pruneNegativeWidthConstraints()

        present(alertController, animated: true)
    }

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker        = UIImagePickerController()
        imagePicker.delegate   = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }
}

// MARK: - Delegates
extension ProfileViewController: ProfileViewDelegate {
    func editButtonPressed() {
        presentRequestPhotoAlert()
    }

    func saveButtonPressed() {
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            profilePhoto = image
        }
        picker.dismiss(animated: true)
    }
}
