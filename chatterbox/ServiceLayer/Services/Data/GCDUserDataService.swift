import Foundation

class GCDUserDataService: UserDataProtocol {

    // MARK: - Properties
    let queue = DispatchQueue.global(qos: .default)
    let group = DispatchGroup()

    // MARK: - Dependencies
    var fileManagerStack: FileManagerStackProtocol

    init(fileManagerStack: FileManagerStackProtocol) {
        self.fileManagerStack = fileManagerStack
    }

    // MARK: - Functions
    func updateModel(with model: User, handler: @escaping (Result<User>) -> Void) {

        var success = false

        group.enter()
        queue.async {
            let resultOfInfoSaving = self.saveInfoToFile(model: model)
            success = resultOfInfoSaving
            self.group.leave()
        }

        group.enter()
        queue.async {
            let resultOfPhotoSaving = self.savePhotoToFile(model: model)
            success = resultOfPhotoSaving
            self.group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.getUserModel { user in
                if success, let user = user {
                    handler(.success(user))
                } else {
                    handler(.error)
                }
            }
        }
    }

    func getUserModel(handler: @escaping (User?) -> Void) {
        queue.sync {
            handler(readUserModel())
        }
    }
}
