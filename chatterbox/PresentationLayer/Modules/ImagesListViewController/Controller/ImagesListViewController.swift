import UIKit

protocol ImagesListViewControllerDelegate: class {
    func handleSelection(_ image: UIImage)
}

class ImagesListViewController: UIViewController {

    // MARK: - Properties
    lazy var imagesListView: ImagesListView = {
        let view = ImagesListView(themesService: model.themesService)
        return view
    }()

    var imageDataModels = [ImageDataModel]()

    weak var delegate: ImagesListViewControllerDelegate?

    // MARK: - Dependencies
    var model: ImagesListModel
    var presentationAssembly: PresentationAssemblyProtocol

    init(model: ImagesListModel, presentationAssembly: PresentationAssemblyProtocol) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Lifecycle
    override func loadView() {
        view = imagesListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        getURLs()
    }

    // MARK: - Functions
    private func setupView() {
        imagesListView.setupUIElements()
        imagesListView.backgroundColor = model.themesService.mainBGColor
        imagesListView.collectionView.delegate = self
        imagesListView.collectionView.dataSource = self
        imagesListView.collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.imageCell)
    }

    private func setupNavigationBar() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                              target: self,
                                              action: #selector(closeButtonPressed))

        navigationItem.leftBarButtonItem = closeButtonItem
        model.themesService.setupNavigationBar(target: self)
    }

    private func getURLs() {
        model.imageLoaderService.loadImageDataModel { [weak self] imageDataModel in
            guard let self = self else { return }
            self.imageDataModels = imageDataModel.imageDataModels
            DispatchQueue.main.async {
                self.imagesListView.collectionView.reloadData()
            }
        }
    }

    // MARK: - Actions
    @objc
    private func closeButtonPressed() {
        dismiss(animated: true)
    }
}
