import UIKit

protocol ProfileViewDelegate: class {
    func editButtonPressed()
    func saveButtonPressed()
}

class ProfileView: UIView {

    // MARK: - UI
    lazy var photoImageView: UIImageView = {
        let photoImageView             = UIImageView()
        photoImageView.contentMode     = .scaleAspectFill
        photoImageView.clipsToBounds   = true
        photoImageView.backgroundColor = UIColor(hex: "#E4E82B")
        return photoImageView
    }()

    lazy var editButton: UIButton = {
        let editButton              = UIButton()
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        editButton.setTitleColor(UIColor.systemBlue, for: .normal)
        editButton.setTitle(NSLocalizedString(NSLocalizedString("Edit", comment: ""), comment: ""), for: .normal)
        return editButton
    }()

    lazy var nameLabel: UILabel = {
        let nameLabel           = UILabel()
        nameLabel.textColor     = ThemesManager.shared.textColor
        nameLabel.font          = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        return nameLabel
    }()

    lazy var descriptionTextView: UITextView = {
        let descriptionTextView             = UITextView()
        descriptionTextView.textColor       = ThemesManager.shared.textColor
        descriptionTextView.font            = .systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.isEditable      = false
        descriptionTextView.isSelectable    = false
        descriptionTextView.backgroundColor = ThemesManager.shared.mainBGColor
        return descriptionTextView
    }()

    lazy var saveButton: UIButton = {
        let saveButton                = UIButton()
        saveButton.titleLabel?.font   = UIFont.systemFont(ofSize: 19, weight: .semibold)
        saveButton.backgroundColor    = UIColor.systemGray.withAlphaComponent(0.2)
        saveButton.layer.cornerRadius = 14
        saveButton.setTitleColor(UIColor.systemBlue, for: .normal)
        saveButton.setTitle(NSLocalizedString(NSLocalizedString("Save", comment: ""), comment: ""), for: .normal)
        return saveButton
    }()

    weak var delegate: ProfileViewDelegate?

    func setupUIElements() {
        addSubviews(photoImageView,
                    editButton,
                    nameLabel,
                    descriptionTextView,
                    saveButton)
        setupPhotoImageViewConstraints()
        setupEditButtonConstraints()
        setupNameLabelConstraints()
        setupDescriptionTextViewConstraints()
        setupSaveButtonConstraints()
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

    private func setupEditButtonConstraints() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.heightAnchor.constraint(equalToConstant: 40),
            editButton.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            editButton.firstBaselineAnchor.constraint(equalTo: photoImageView.bottomAnchor)
        ])
    }

    private func setupNameLabelConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 32),
            nameLabel.bottomAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: -32)
        ])
    }

    private func setupDescriptionTextViewConstraints() {
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            descriptionTextView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            descriptionTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 32),
            descriptionTextView.bottomAnchor.constraint(greaterThanOrEqualTo: saveButton.topAnchor, constant: -32)
        ])
    }

    private func setupSaveButtonConstraints() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 56),
            saveButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -56),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
}
