import UIKit

class ProfileViewController: UIViewController, ConfigurableView, UINavigationControllerDelegate {

    // MARK: - Properties
    private lazy var profileView: ProfileView = {
        let view = ProfileView(frame: UIScreen.main.bounds)
        return view
    }()

    private var profileModel: UserModel
    private var updatedModel: UserModel
    var updateUserIcon: (() -> Void)?

    typealias ConfigurationModel = UserModel

    private var isTextViewEditable: Bool = false {
        willSet(isEditable) {
            let textViewBGColor: UIColor
            if isEditable {
                textViewBGColor = ThemesManager.shared.incomingMessageBGColor
            } else {
                configure(with: profileModel)
                isAbleToSave = false
                textViewBGColor = .clear
            }
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.profileView.nameTextView.backgroundColor = textViewBGColor
                self.profileView.descriptionTextView.backgroundColor = textViewBGColor
                self.profileView.nameTextView.isEditable = isEditable
                self.profileView.descriptionTextView.isEditable = isEditable
            }
        }
    }

    private var isSaving: Bool = false {
        willSet(isSaving) {
            if isSaving {
                profileView.activityIndicator.startAnimating()
            } else {
                profileView.activityIndicator.stopAnimating()
            }
            profileView.saveButtonGCD.isEnabled = !isSaving
            profileView.saveButtonOperation.isEnabled = !isSaving
        }
    }

    private var isAbleToSave: Bool = false {
        willSet {
            profileView.saveButtonGCD.isEnabled = newValue
            profileView.saveButtonOperation.isEnabled = newValue
        }
    }

    init(with profileModel: UserModel) {
        self.profileModel = profileModel
        self.updatedModel = profileModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Lifecycle
    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure(with: profileModel)
        setupNavigationBar()
        hideKeyboardWhenTappedOutside()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObserver()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileView.photoImageView.layer.cornerRadius = profileView.photoImageView.frame.size.width / 2
    }

    // MARK: - Functions
    private func setupView() {
        profileView.setupUIElements()
        profileView.backgroundColor = ThemesManager.shared.mainBGColor
        profileView.nameTextView.delegate = self
        profileView.descriptionTextView.delegate = self

        profileView.editPhotoButton.addTarget(self, action: #selector(editPhotoButtonPressed), for: .touchUpInside)
        profileView.saveButtonGCD.addTarget(self, action: #selector(saveButtonGCDPressed), for: .touchUpInside)
        profileView.saveButtonOperation.addTarget(self, action: #selector(saveButtonOperationPressed), for: .touchUpInside)
    }

    private func setupNavigationBar() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                              target: self,
                                              action: #selector(closeButtonPressed))

        let editInfoButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                 target: self,
                                                 action: #selector(editInfoButtonPressed))
        editInfoButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
                                                  for: .normal)

        navigationItem.leftBarButtonItem = closeButtonItem
        navigationItem.rightBarButtonItem = editInfoButtonItem
        ThemesManager.shared.setupNavigationBar(target: self)
    }

    func configure(with model: ConfigurationModel) {
        profileView.photoImageView.image = model.accountIcon
        profileView.nameTextView.text = model.name
        profileView.descriptionTextView.text = model.description
    }

    private func presentRequestPhotoAlert() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)

        let photoLibraryAction = UIAlertAction(title: NSLocalizedString("Photo library", comment: ""),
                                               style: .default) { [weak self] _ in
                                                guard let self = self else { return }
                                                self.presentImagePicker(sourceType: .photoLibrary)
        }

        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""),
                                         style: .default) { [weak self] _ in
                                            guard let self = self else { return }
                                            let accessChecker = AccessChecker()
                                            accessChecker.checkCameraAccess(target: self) { result in
                                                #if targetEnvironment(simulator)
                                                return
                                                #else
                                                guard result != .error else { return }
                                                self.presentImagePicker(sourceType: .camera)
                                                #endif
                                            }
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel)

        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)

        alertController.pruneNegativeWidthConstraints()

        present(alertController, animated: true)
    }

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }

    private func textViewValidate() {
        guard let name = profileView.nameTextView.text,
            let description = profileView.descriptionTextView.text,
            !profileView.nameTextView.text.isEmpty,
            !profileView.descriptionTextView.text.isEmpty
            else { return }

        let state = (name != profileModel.name || description != profileModel.description) ? true : false
        updatedModel.name = name
        updatedModel.description = description
        isAbleToSave = state
    }

    private func saveData() {
        isSaving = true
        isAbleToSave = false
        UserManager.shared.dataManager.updateModel(with: updatedModel) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isSaving = false
                self.isTextViewEditable = false
                switch result {
                case .success:
                    self.configure(with: self.updatedModel)
                    self.updateUserIcon?()
                    self.profileModel = self.updatedModel
                    self.presentSuccessAlert()
                    Logger.shared.printLogs(text: "Model saved and applied")

                case .error:
                    self.presentErrorAlert()
                }
            }
        }
    }

    private func presentSuccessAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("Data is saved", comment: ""),
                                                message: nil,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                     style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    private func presentErrorAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                                message: NSLocalizedString("Unable to save data", comment: ""),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                     style: .default)

        let retryAction = UIAlertAction(title: NSLocalizedString("Retry", comment: ""),
                                        style: .default) { [weak self] _ in
                                            guard let self = self else { return }
                                            self.saveData()
        }

        alertController.addAction(okAction)
        alertController.addAction(retryAction)

        present(alertController, animated: true)
    }

    // MARK: - Actions
    @objc
    private func closeButtonPressed() {
        dismiss(animated: true)
    }

    @objc
    private func editInfoButtonPressed() {
        isTextViewEditable.toggle()
    }

    @objc
    private func editPhotoButtonPressed() {
        presentRequestPhotoAlert()
    }

    @objc
    private func saveButtonGCDPressed() {
        UserManager.shared.dataManager = GCDDataManager()
        saveData()
    }

    @objc
    private func saveButtonOperationPressed() {
        UserManager.shared.dataManager = OperationDataManager()
        saveData()
    }
}

// MARK: - Delegates
extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage,
            let resizedImage = image.resizeImage(image: image, newWidth: 300) {
            profileView.photoImageView.image = resizedImage
            updatedModel.photo = resizedImage
            isAbleToSave = true
        }
        picker.dismiss(animated: true)
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewValidate()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}
