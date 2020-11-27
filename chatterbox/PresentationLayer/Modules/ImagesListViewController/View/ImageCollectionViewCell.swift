import UIKit

class ImageCollectionViewCell: UICollectionViewCell, ConfigurableView {

    typealias ConfigurationModel = ImageCellModel

    // MARK: - UI
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.75)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = Images.imagePlaceHolder
        return imageView
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    // MARK: - Dependencies
    var imageLoaderService: ImageLoaderServiceProtocol?
    var taskURLString: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = Images.imagePlaceHolder

        if let taskURLString = taskURLString {
            imageLoaderService?.cancelTaskWithUrl(urlString: taskURLString)
        }
    }

    private func setupUIElements() {
        addSubviews(imageView, activityIndicator)
        setupImageViewConstraints()
        setupActivityIndicatorConstraints()
    }

    func configure(with model: ConfigurationModel) {
        imageView.image = model.image
        activityIndicator.stopAnimating()
    }

    // MARK: - Constraints
    private func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }
}
