import UIKit

struct ProfileModel {
    var photo: UIImage?
    var name: String
    var description: String

    var initials: String {
        let namesArray = name.split(separator: " ")
        guard namesArray.count == 2 else { return "" }
        let firstCharacters = namesArray.compactMap { $0.first }
        return String(firstCharacters)
    }

    var accountIcon: UIImage {
        if let photo = photo {
            return photo
        } else {
            let initialsLabel             = UILabel()
            initialsLabel.frame.size      = CGSize(width: 240, height: 240)
            initialsLabel.textColor       = Colors.textBlack
            initialsLabel.font            = UIFont(name: "Roboto-Regular", size: 120)
            initialsLabel.text            = initials
            initialsLabel.textAlignment   = .center
            initialsLabel.backgroundColor = Colors.customYellow

            let image = UIImage.imageWithLabel(initialsLabel)

            return image
        }
    }
}
