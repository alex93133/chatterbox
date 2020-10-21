import Foundation

class OperationDataManager: DataManager {

    // MARK: - Properties
    var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let operationQueue = OperationQueue()

    // MARK: - Functions
    func updateModel(with model: UserModel, handler: @escaping (Result) -> Void) {
        var success = false

        let infoSavingOperation = BlockOperation { [weak self] in
            guard let self = self else { return }
            let resultOfInfoSaving = self.saveInfoToFile(model: model)
            success = resultOfInfoSaving
        }

        let photoSavingOperation = BlockOperation { [weak self] in
            guard let self = self else { return }
            let resultOfPhotoSaving = self.savePhotoToFile(model: model)
            success = resultOfPhotoSaving
        }

        let completionOperation = BlockOperation { [weak self] in
            guard let self = self else { return }
            self.getUserModel { newModel in
                if success, let model = newModel {
                    UserManager.shared.userModel = model
                    handler(.success)
                } else {
                    handler(.error)
                }
            }
        }

        completionOperation.addDependency(infoSavingOperation)
        completionOperation.addDependency(photoSavingOperation)
        operationQueue.addOperation(infoSavingOperation)
        operationQueue.addOperation(photoSavingOperation)
        operationQueue.addOperation(completionOperation)
    }

    func getUserModel(handler: @escaping (UserModel?) -> Void) {
        var userModel: UserModel!

        let readingOperation = BlockOperation { [weak self] in
            guard let self = self else { return }
            userModel = self.readUserModel()
            handler(userModel)
        }

        operationQueue.addOperation(readingOperation)
    }
}
