import UIKit

class ImagesListView: UIView {

    // MARK: - UI
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

        let numberOfItemsInRow: CGFloat = 3
        let spacing: CGFloat = 4

        let itemSize: CGFloat = (frame.size.width - layout.sectionInset.left - layout.sectionInset.right -
                                    (numberOfItemsInRow - 1) * spacing) / numberOfItemsInRow

        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
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
        addSubviews(collectionView)
        setupCollectionViewConstraints()
    }

    // MARK: - Constraints
    private func setupCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
