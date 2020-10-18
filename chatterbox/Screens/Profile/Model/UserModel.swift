import UIKit

struct UserModel: Equatable {

    var photo: UIImage?
    var name: String
    var description: String
    var theme: ThemeModel
    var uuID: String

    var initials: String {
        let namesArray = name.split(separator: " ")
        guard 1 ... 2 ~= namesArray.count else { return "" }
        let firstCharacters = namesArray.compactMap { $0.first }
        return String(firstCharacters)
    }

    var accountIcon: UIImage {
        if let photo = photo {
            return photo
        } else {
            let initialsLabel = UILabel()
            initialsLabel.frame.size = CGSize(width: 240, height: 240)
            initialsLabel.textColor = UIColor(hex: "363738")
            initialsLabel.font = UIFont(name: "Roboto-Regular", size: 120)
            initialsLabel.text = initials
            initialsLabel.textAlignment = .center
            initialsLabel.backgroundColor = UIColor(hex: "#E4E82B")

            let image = UIImage.imageWithLabel(initialsLabel)

            return image
        }
    }
}
