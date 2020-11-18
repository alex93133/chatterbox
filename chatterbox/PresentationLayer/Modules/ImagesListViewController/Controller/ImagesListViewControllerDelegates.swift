import UIKit

extension ImagesListViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDataModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.imageCell,
                                                         for: indexPath) as? ImageCollectionViewCell {
            let imageDataModel = imageDataModels[indexPath.item]

            if let image = imageDataModels[indexPath.item].image {
                cell.configure(with: ImageCellModel(image: image))
            } else {
                cell.configure(with: ImageCellModel(image: Images.imagePlaceHolder))
                cell.activityIndicator.startAnimating()

                model.imageLoaderService.loadImage(urlString: imageDataModel.urlString) { image in
                    cell.activityIndicator.stopAnimating()
                    self.imageDataModels[indexPath.item].image = image
                    cell.configure(with: ImageCellModel(image: image))
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = imageDataModels[indexPath.item].image else { return }
        delegate?.handleSelection(image)
        dismiss(animated: true)
    }
}
