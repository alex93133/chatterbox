import UIKit

struct User: Equatable {

    var photo: UIImage?
    var name: String
    var description: String
    var theme: Theme
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

extension User {
    init?(dictionary: NSMutableDictionary, photo: UIImage?) {
        guard let name = dictionary.object(forKey: "name") as? String,
              let description = dictionary.object(forKey: "description") as? String,
              let themeString = dictionary.object(forKey: "theme") as? String,
              let theme = Theme(rawValue: themeString),
              let uuid = dictionary.object(forKey: "uuid") as? String
        else { return nil }

        self.name = name
        self.description = description
        self.theme = theme
        self.uuID = uuid
        self.photo = photo
    }
}
