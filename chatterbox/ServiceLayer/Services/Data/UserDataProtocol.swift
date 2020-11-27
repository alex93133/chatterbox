import UIKit

protocol UserDataProtocol {
    func updateModel(with model: User, handler:  @escaping (Result<User, FileManagerError>) -> Void)
    func getUserModel(handler: @escaping (User?) -> Void)
    var fileManagerStack: FileManagerStackProtocol { get }
}

extension UserDataProtocol {
    // MARK: - Properties
    var photoURL: URL {
        return fileManagerStack.documentDirectory.appendingPathComponent("/photo.png")
    }

    var plistURL: URL {
        return fileManagerStack.documentDirectory.appendingPathComponent("/info.plist")
    }

    // MARK: - Functions
    func readUserModel() -> User? {
        guard let dictionary = NSMutableDictionary(contentsOfFile: plistURL.path) else { return nil }
        let photo = getPhoto()
        let userModel = User(dictionary: dictionary, photo: photo)
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

    func createUser(model: User) {
        let fileManager = fileManagerStack.fileManager
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

    func saveInfoToFile(model: User) -> Bool {
        if let dictionary = NSMutableDictionary(contentsOfFile: plistURL.path) {
            dictionary["name"] = model.name
            dictionary["description"] = model.description
            dictionary["theme"] = model.theme.rawValue
            do {
                try dictionary.write(to: plistURL)
                return true
            } catch {
                Logger.shared.printLogs(text: "Info saving failed \(error.localizedDescription)")
            }
        }
        return false
    }

    func savePhotoToFile(model: User) -> Bool {
        if let image = model.photo,
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
