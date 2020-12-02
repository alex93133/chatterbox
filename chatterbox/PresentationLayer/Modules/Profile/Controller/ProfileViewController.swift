import UIKit

class ProfileViewController: UIViewController, ConfigurableView {

    // MARK: - Properties
    lazy var profileView: ProfileView = {
        let view = ProfileView(themesService: model.themesService)
        return view
    }()

    lazy var logoEmitter: LogoEmitterAnimation = {
        let logoEmitter = LogoEmitterAnimation(target: profileView)
        return logoEmitter
    }()

    lazy var shakingAnimation: ShakingAnimation? = {
        if let buttonView = editInfoButtonItem.customView {
            let shakingAnimation = ShakingAnimation(target: buttonView)
            return shakingAnimation
        } else {
            return nil
        }
    }()

    var profileModel: User
    var updatedModel: User
    var updateUserIcon: (() -> Void)?
    var editInfoButtonItem: UIBarButtonItem!

    typealias ConfigurationModel = User

    private var isTextViewEditable: Bool = false {
        willSet(isEditable) {
            let textViewBGColor: UIColor
            if isEditable {
                textViewBGColor = model.themesService.incomingMessageBGColor
            } else {
                configure(with: profileModel)
                isAbleToSave = false
                textViewBGColor = .clear
            }
            profileView.animateInputs(isEditable: isEditable,
                                      bgColor: textViewBGColor)
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

    var isAbleToSave: Bool = false {
        willSet {
            profileView.saveButtonGCD.isEnabled = newValue
            profileView.saveButtonOperation.isEnabled = newValue
        }
    }

    // MARK: - Dependencies
    var model: ProfileModelProtocol
    var presentationAssembly: PresentationAssemblyProtocol

    init(model: ProfileModelProtocol, presentationAssembly: PresentationAssemblyProtocol) {
        self.model = model
        self.presentationAssembly = presentationAssembly

        self.profileModel = model.user
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
        profileView.backgroundColor = model.themesService.mainBGColor
        profileView.nameTextView.delegate = self
        profileView.descriptionTextView.delegate = self

        profileView.saveButtonGCD.addTarget(self, action: #selector(saveButtonGCDPressed), for: .touchUpInside)
        profileView.saveButtonOperation.addTarget(self, action: #selector(saveButtonOperationPressed), for: .touchUpInside)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editPhotoButtonPressed))
        profileView.photoImageView.addGestureRecognizer(gestureRecognizer)
        logoEmitter.addLogoEmitter()
    }

    private func setupNavigationBar() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                              target: self,
                                              action: #selector(closeButtonPressed))

        let icon = Images.edit
        let iconSize = CGRect(origin: .zero, size: icon.size)
        let iconButton = UIButton(frame: iconSize)
        iconButton.addTarget(self, action: #selector(editInfoButtonPressed), for: .touchUpInside)
        iconButton.setBackgroundImage(icon, for: .normal)

        editInfoButtonItem = UIBarButtonItem(customView: iconButton)

        editInfoButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
                                                  for: .normal)

        navigationItem.leftBarButtonItem = closeButtonItem
        navigationItem.rightBarButtonItem = editInfoButtonItem
        model.themesService.setupNavigationBar(target: self)
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
            let accessChecker = AccessCheckerService()
            accessChecker.checkCameraAccess(target: self) { result in
                #if targetEnvironment(simulator)
                return
                #else
                guard result != .error else { return }
                self.presentImagePicker(sourceType: .camera)
                #endif
            }
        }

        let imagesListAction = UIAlertAction(title: NSLocalizedString("Upload", comment: ""),
                                             style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presentImageList()
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel)

        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(imagesListAction)
        alertController.addAction(cancelAction)

        alertController.pruneNegativeWidthConstraints()

        present(alertController, animated: true)
    }

    private func presentImageList() {
        let imagesListViewController = presentationAssembly.imagesListViewController()
        imagesListViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: imagesListViewController)
        present(navigationController, animated: true)
    }

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }

    private func saveData() {
        isSaving = true
        isAbleToSave = false
        model.userDataService.dataManager.updateModel(with: updatedModel) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isSaving = false
                self.isTextViewEditable = false
                self.shakingAnimation?.cancel()
                switch result {
                case .success (let user):
                    self.model.userDataService.userModel = user
                    self.configure(with: user)
                    self.updateUserIcon?()
                    self.profileModel = user
                    self.presentSuccessAlert()
                    Logger.shared.printLogs(text: "Model saved and applied")

                case .failure:
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

        if isTextViewEditable {
            shakingAnimation?.start(angle: 18, offset: 5)
        } else {
            shakingAnimation?.cancel()
        }

    }

    @objc
    private func editPhotoButtonPressed() {
        presentRequestPhotoAlert()
    }

    @objc
    private func saveButtonGCDPressed() {
        model.userDataService.dataManager = model.userDataService.gcdUserDataService
        saveData()
    }

    @objc
    private func saveButtonOperationPressed() {
        model.userDataService.dataManager = model.userDataService.operationUserDataService
        saveData()
    }
}
