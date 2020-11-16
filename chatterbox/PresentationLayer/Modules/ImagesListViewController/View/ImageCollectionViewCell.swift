import UIKit

class ImageCollectionViewCell: UICollectionViewCell, ConfigurableView {
    
    typealias ConfigurationModel = ImageCellModel
    
    // MARK: - UI
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.imagePlaceHolder
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.75)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUIElements() {
        addSubviews(imageView, activityIndicator)
        setupImageViewConstraints()
        setupActivityIndicatorConstraints()
    }
    
    func configure(with model: ConfigurationModel) {
        imageView.image = model.image
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
