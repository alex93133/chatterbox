import UIKit

class ProfileViewController: UIViewController, ConfigurableView, UINavigationControllerDelegate {

    // MARK: - Properties
    private let customView = ProfileView(frame: UIScreen.main.bounds)
    var profileModel: ProfileModel
    typealias ConfigurationModel = ProfileModel

    init(with profileModel: ProfileModel) {
        self.profileModel = profileModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure(with: profileModel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customView.photoImageView.layer.cornerRadius = customView.photoImageView.frame.size.width / 2
    }

    // MARK: - Functions
    private func setupView() {
        customView.setupUIElements()
        view                       = customView
        customView.backgroundColor = ThemesManager.shared.mainBGColor
        customView.editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        customView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }

    func configure(with model: ConfigurationModel) {
        customView.photoImageView.image     = model.accountIcon
        customView.nameLabel.text           = model.name
        customView.descriptionTextView.text = model.description
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

    // MARK: - Actions
    @objc
    private func editButtonPressed() {
        presentRequestPhotoAlert()
    }

    @objc
    private func saveButtonPressed() {
        print("Save button action")
    }
}

// MARK: - Delegates
extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            customView.photoImageView.image = image
        }
        picker.dismiss(animated: true)
    }
}
