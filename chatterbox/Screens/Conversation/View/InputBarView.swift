import UIKit

class InputBarView: UIView {

    // MARK: - Properties
    lazy var inputTextView: UITextView = {
        let inputTextField = UITextView()
        inputTextField.backgroundColor = ThemesManager.shared.mainBGColor
        inputTextField.keyboardAppearance = ThemesManager.shared.keyBoard
        inputTextField.isScrollEnabled = false
        inputTextField.font = .systemFont(ofSize: 17, weight: .regular)
        inputTextField.layer.cornerRadius = 16
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

    let maxContentHeight: CGFloat = 150

    init() {
        super.init(frame: .zero)
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
        NSLayoutConstraint.activate([
            inputTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            inputTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -19),
            inputTextView.heightAnchor.constraint(lessThanOrEqualToConstant: maxContentHeight)
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
