import UIKit

protocol DataManager {
    func updateModel(with model: UserModel, handler:  @escaping (Result) -> Void)
    func getUserModel(handler: @escaping (UserModel?) -> Void)
    var documentDirectory: URL { get }
}

extension DataManager {
    // MARK: - Properties
    var photoURL: URL {
        return documentDirectory.appendingPathComponent("/photo.png")
    }

    var plistURL: URL {
        return documentDirectory.appendingPathComponent("/info.plist")
    }

    // MARK: - Functions
    func readUserModel() -> UserModel? {
        guard let dictionary = NSMutableDictionary(contentsOfFile: plistURL.path),
            let name = dictionary.object(forKey: "name") as? String,
            let description = dictionary.object(forKey: "description") as? String,
            let themeString = dictionary.object(forKey: "theme") as? String,
            let theme = ThemeModel(rawValue: themeString),
            let uuid = dictionary.object(forKey: "uuid") as? String
            else {
                return nil
        }
        let photo = getPhoto()

        let userModel = UserModel(photo: photo,
                                  name: name,
                                  description: description,
                                  theme: theme,
                                  uuID: uuid)
        return userModel
    }

    func getPhoto() -> UIImage? {
        do {
            let imageData = try Data(contentsOf: photoURL)
            return UIImage(data: imageData)
        } catch {
            return nil
        }
    }

    func createUser(model: UserModel) {
        let fileManager = FileManager.default
        guard !fileManager.fileExists(atPath: plistURL.path) else { return }
        let data: [String: String] = [
            "name": model.name,
            "description": model.description,
            "theme": model.theme.rawValue,
            "uuid": model.uuID
        ]
        let dictionary = NSDictionary(dictionary: data)
        let isCreated = dictionary.write(toFile: plistURL.path, atomically: true)
        Logger.shared.printLogs(text: "User is created: \(isCreated)")
    }

    func saveInfoToFile(model: UserModel) -> Bool {
        let previousModel = UserManager.shared.userModel
        if let dictionary = NSMutableDictionary(contentsOfFile: plistURL.path) {
            if previousModel.name != model.name {
                dictionary["name"] = model.name
            }

            if previousModel.description != model.description {
                dictionary["description"] = model.description
            }

            if previousModel.theme != model.theme {
                dictionary["theme"] = model.theme.rawValue
            }

            do {
                try dictionary.write(to: plistURL)
                return true
            } catch {
                Logger.shared.printLogs(text: "Info saving failed \(error.localizedDescription)")
            }
        }
        return false
    }

    func savePhotoToFile(model: UserModel) -> Bool {
        let previousModel = UserManager.shared.userModel
        if previousModel.photo != model.photo,
            let image = model.photo,
            let data = image.pngData() {
            do {
                try data.write(to: photoURL)
                return true
            } catch {
                Logger.shared.printLogs(text: "Photo saving failed \(error.localizedDescription)")
            }
        }
        return false
    }
}
