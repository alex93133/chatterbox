import UIKit

class ImagesListViewController: UIViewController {
    
    // MARK: - Properties
    lazy var imagesListView: ImagesListView = {
        let view = ImagesListView(themesService: model.themesService)
        return view
    }()
    
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
    
    // MARK: - Actions
    @objc
    private func closeButtonPressed() {
        dismiss(animated: true)
    }
}
