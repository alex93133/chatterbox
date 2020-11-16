import UIKit

extension ImagesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.imageCell,
                                                         for: indexPath) as? ImageCollectionViewCell {
            cell.activityIndicator.startAnimating()
            return cell
        }
        return UICollectionViewCell()
    }
}
