import Foundation

class OperationUserDataService: UserDataProtocol {

    // MARK: - Properties
    let operationQueue = OperationQueue()
    
    // MARK: - Dependencies
//    var userDataService: UserDataServiceProtocol 
    var fileManagerStack: FileManagerStackProtocol
    
    init(userDataService: UserDataServiceProtocol, fileManagerStack: FileManagerStackProtocol) {
//        self.userDataService = userDataService
        self.fileManagerStack = fileManagerStack
    }
    
    // MARK: - Functions
    func updateModel(with model: User, handler: @escaping (Result) -> Void) {
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
//                if success, let model = newModel {
//                    self.userDataService.userModel = model
//                    handler(.success)
//                } else {
//                    handler(.error)
//                }
            }
        }

        completionOperation.addDependency(infoSavingOperation)
        completionOperation.addDependency(photoSavingOperation)
        operationQueue.addOperation(infoSavingOperation)
        operationQueue.addOperation(photoSavingOperation)
        operationQueue.addOperation(completionOperation)
    }

    func getUserModel(handler: @escaping (User?) -> Void) {
        var userModel: User!

        let readingOperation = BlockOperation { [weak self] in
            guard let self = self else { return }
            userModel = self.readUserModel()
            handler(userModel)
        }

        operationQueue.addOperation(readingOperation)
    }
}
