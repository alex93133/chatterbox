import UIKit

protocol ProfileViewDelegate: class {
    func editButtonPressed()
    func saveButtonPressed()
}

class ProfileView: UIView {

    // MARK: - Properties
    var profilePhotoImageView: UIImageView!
    var initialsLabel: UILabel!
    var editButton: UIButton!
    var profileNameLabel: UILabel!
    var profileDescriptionLabel: UILabel!
    var saveButton: UIButton!

    weak var delegate: ProfileViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProfilePhotoImageView()
        setupInitialsLabel()
        setupEditButton()
        setupProfileNameLabel()
        setupProfileDescriptionLabel()
        setupSaveButton()
        backgroundColor = Colors.mainBG
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI elements
    private func setupProfilePhotoImageView() {
        profilePhotoImageView                 = UIImageView()
        profilePhotoImageView.contentMode     = .scaleAspectFill
        profilePhotoImageView.clipsToBounds   = true
        profilePhotoImageView.backgroundColor = Colors.customYellow
        setupProfilePhotoImageViewConstraints()
    }

    private func setupInitialsLabel() {
        initialsLabel                 = UILabel()
        initialsLabel.textColor       = Colors.textBlack
        initialsLabel.font            = UIFont(name: "Roboto-Regular", size: 120)
        initialsLabel.textAlignment   = .center
        setupInitialsLabelConstraints()
    }

    private func setupEditButton() {
        editButton                  = UIButton()
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        editButton.setTitleColor(Colors.textBlue, for: .normal)
        editButton.setTitle(NSLocalizedString(NSLocalizedString("Edit", comment: ""), comment: ""), for: .normal)
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        setupEditButtonConstraints()
    }

    private func setupProfileNameLabel() {
        profileNameLabel               = UILabel()
        profileNameLabel.textColor     = Colors.textBlack
        profileNameLabel.font          = .systemFont(ofSize: 24, weight: .bold)
        profileNameLabel.textAlignment = .center
        profileNameLabel.text          = "Marina Dudarenko"
        setupProfileNameLabelConstraints()
    }

    private func setupProfileDescriptionLabel() {
        profileDescriptionLabel               = UILabel()
        profileDescriptionLabel.textColor     = Colors.textBlack
        profileDescriptionLabel.font          = .systemFont(ofSize: 16, weight: .regular)
        profileDescriptionLabel.numberOfLines = 0
        profileDescriptionLabel.text          = "UX/UI designer, web-designer\nMoscow, Russia"
        setupProfileDescriptionLabelConstraints()
    }

    private func setupSaveButton() {
        saveButton                    = UIButton()
        saveButton.titleLabel?.font   = UIFont.systemFont(ofSize: 19, weight: .semibold)
        saveButton.backgroundColor    = Colors.additionalBG
        saveButton.layer.cornerRadius = 14
        saveButton.setTitleColor(Colors.textBlue, for: .normal)
        saveButton.setTitle(NSLocalizedString(NSLocalizedString("Save", comment: ""), comment: ""), for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        setupSaveButtonConstraints()
    }

    // MARK: - Actions
    @objc
    private func editButtonPressed() {
        delegate?.editButtonPressed()
    }

    @objc
    private func saveButtonPressed() {
        delegate?.saveButtonPressed()
    }

    // MARK: - Constraints
    private func setupProfilePhotoImageViewConstraints() {
        addSubview(profilePhotoImageView)

        profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePhotoImageView.widthAnchor.constraint(equalToConstant: 240),
            profilePhotoImageView.heightAnchor.constraint(equalToConstant: 240),
            profilePhotoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 45),
            profilePhotoImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func setupInitialsLabelConstraints() {
        addSubview(initialsLabel)

        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            initialsLabel.leadingAnchor.constraint(equalTo: profilePhotoImageView.leadingAnchor),
            initialsLabel.topAnchor.constraint(equalTo: profilePhotoImageView.topAnchor),
            initialsLabel.trailingAnchor.constraint(equalTo: profilePhotoImageView.trailingAnchor),
            initialsLabel.bottomAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor)
        ])
    }

    private func setupEditButtonConstraints() {
        addSubview(editButton)

        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.heightAnchor.constraint(equalToConstant: 40),
            editButton.trailingAnchor.constraint(equalTo: profilePhotoImageView.trailingAnchor),
            editButton.firstBaselineAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor)
        ])
    }

    private func setupProfileNameLabelConstraints() {
        addSubview(profileNameLabel)

        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 80),
            profileNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -80),
            profileNameLabel.heightAnchor.constraint(equalToConstant: 20),
            profileNameLabel.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor, constant: 32)
        ])
    }

    private func setupProfileDescriptionLabelConstraints() {
        addSubview(profileDescriptionLabel)

        profileDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileDescriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 78),
            profileDescriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -78),
            profileDescriptionLabel.heightAnchor.constraint(equalToConstant: 44),
            profileDescriptionLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 32)
        ])
    }

    private func setupSaveButtonConstraints() {
        addSubview(saveButton)

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 56),
            saveButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -56),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
}
