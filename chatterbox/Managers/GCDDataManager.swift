import Foundation

struct GCDDataManager: DataManager {

    // MARK: - Properties
    let queue = DispatchQueue.global(qos: .default)
    let group = DispatchGroup()
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    // MARK: - Functions
    func updateModel(with model: UserModel, handler: @escaping (Result) -> Void) {

        var success = false

        group.enter()
        queue.async {
            let resultOfInfoSaving = saveInfoToFile(model: model)
            success = resultOfInfoSaving
            group.leave()
        }

        group.enter()
        queue.async {
            let resultOfPhotoSaving = savePhotoToFile(model: model)
            success = resultOfPhotoSaving
            group.leave()
        }

        group.notify(queue: .main) {
            self.getUserModel { newModel in
                if success {
                    UserManager.shared.userModel = newModel
                    handler(.success)
                } else {
                    handler(.error)
                }
            }
        }
    }

    func getUserModel(handler: @escaping (UserModel) -> Void) {
        queue.sync {
            handler(readUserModel())
        }
    }
}
