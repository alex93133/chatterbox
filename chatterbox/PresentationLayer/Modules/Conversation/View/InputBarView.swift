import UIKit

class InputBarView: UIView {

    // MARK: - Properties
    lazy var inputTextView: UITextView = {
        let inputTextField = UITextView()
        inputTextField.backgroundColor = themesService.mainBGColor
        inputTextField.keyboardAppearance = themesService.keyboardStyle
        inputTextField.isScrollEnabled = false
        inputTextField.font = .systemFont(ofSize: 17, weight: .regular)
        inputTextField.layer.cornerRadius = 16
        inputTextField.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return inputTextField
    }()

    lazy var sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.setImage(Images.send, for: .normal)
        return sendButton
    }()

    lazy var splitLineView: UIView = {
        let splitLineView = UIView()
        splitLineView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        return splitLineView
    }()

    var textViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Dependencies
    var themesService: ThemesServiceProtocol

    init(themesService: ThemesServiceProtocol) {
        self.themesService = themesService
        super.init(frame: UIScreen.main.bounds)
        setupUIElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUIElements() {
        addSubviews(inputTextView,
                    sendButton,
                    splitLineView)
        setupInputTextViewConstraints()
        setupSendButtonConstraints()
        setupSplitLineViewConstraints()
    }

    // MARK: - Constraints
    private func setupInputTextViewConstraints() {
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        textViewHeightConstraint = inputTextView.heightAnchor.constraint(equalToConstant: 36)
        NSLayoutConstraint.activate([
            inputTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            inputTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -19),
            textViewHeightConstraint
        ])
    }

    private func setupSendButtonConstraints() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            sendButton.centerYAnchor.constraint(equalTo: inputTextView.centerYAnchor)
        ])
    }

    private func setupSplitLineViewConstraints() {
        splitLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            splitLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            splitLineView.topAnchor.constraint(equalTo: topAnchor),
            splitLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            splitLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
