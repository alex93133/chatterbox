import UIKit

class ProfileView: UIView {

    // MARK: - UI
    lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = UIColor(hex: "#E4E82B")
        photoImageView.isUserInteractionEnabled = true
        return photoImageView
    }()

    lazy var nameTextView: UITextView = {
        let nameTextView = UITextView()
        nameTextView.textColor = themesService.textColor
        nameTextView.keyboardAppearance = themesService.keyboardStyle
        nameTextView.font = .systemFont(ofSize: 24, weight: .bold)
        nameTextView.isSelectable = false
        nameTextView.isScrollEnabled = false
        nameTextView.isEditable = false
        nameTextView.returnKeyType = .done
        nameTextView.backgroundColor = .clear
        nameTextView.textAlignment = .center
        nameTextView.layer.cornerRadius = 8
        nameTextView.accessibilityIdentifier = "nameTextView"
        return nameTextView
    }()

    lazy var descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.textColor = themesService.textColor
        descriptionTextView.keyboardAppearance = themesService.keyboardStyle
        descriptionTextView.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.isSelectable = false
        descriptionTextView.isEditable = false
        descriptionTextView.returnKeyType = .done
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.accessibilityIdentifier = "descriptionTextView"
        return descriptionTextView
    }()

    lazy var saveButtonGCD: SaveButton = {
        let saveButtonGCD = SaveButton(title: "GCD")
        saveButtonGCD.isEnabled = false
        return saveButtonGCD
    }()

    lazy var saveButtonOperation: SaveButton = {
        let saveButtonOperation = SaveButton(title: "Operation")
        saveButtonOperation.isEnabled = false
        return saveButtonOperation
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    // MARK: - Dependencies
    var themesService: ThemesServiceProtocol

    init(themesService: ThemesServiceProtocol) {
        self.themesService = themesService
        super.init(frame: UIScreen.main.bounds)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUIElements() {
        addSubviews(photoImageView,
                    nameTextView,
                    descriptionTextView,
                    saveButtonGCD,
                    saveButtonOperation,
                    activityIndicator)
        setupPhotoImageViewConstraints()
        setupNameTextViewConstraints()
        setupDescriptionTextViewConstraints()
        setupSaveButtonGCDConstraints()
        setupSaveButtonOperationConstraints()
        setupActivityIndicatorConstraints()
    }

    // MARK: - Animations
    func animateInputs(isEditable: Bool, bgColor: UIColor) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.nameTextView.backgroundColor = bgColor
            self.descriptionTextView.backgroundColor = bgColor
            self.nameTextView.isEditable = isEditable
            self.descriptionTextView.isEditable = isEditable
        }
    }

    // MARK: - Constraints
    private func setupPhotoImageViewConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1),
            photoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 45),
            photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func setupNameTextViewConstraints() {
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            nameTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            nameTextView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 32),
            nameTextView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupDescriptionTextViewConstraints() {
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            descriptionTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            descriptionTextView.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: 32),
            descriptionTextView.bottomAnchor.constraint(greaterThanOrEqualTo: saveButtonGCD.topAnchor, constant: -32)
        ])
    }

    private func setupSaveButtonGCDConstraints() {
        saveButtonGCD.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButtonGCD.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButtonGCD.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: -8),
            saveButtonGCD.heightAnchor.constraint(equalToConstant: 40),
            saveButtonGCD.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    private func setupSaveButtonOperationConstraints() {
        saveButtonOperation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButtonOperation.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButtonOperation.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 8),
            saveButtonOperation.heightAnchor.constraint(equalToConstant: 40),
            saveButtonOperation.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    private func setupActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
