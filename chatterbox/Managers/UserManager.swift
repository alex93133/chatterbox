import UIKit

class UserManager {

    static let shared = UserManager()
    private init() {}

    var dataManager: DataManager = GCDDataManager()
    //    var dataManager: DataManager = OperationDataManager()

    let semaphore = DispatchSemaphore(value: 0)

    private var currentModel: UserModel?
    var userModel: UserModel {
        get {
            if let currentModel = currentModel {
                return currentModel
            } else {
                var model: UserModel!
                dataManager.getUserModel { [weak self] userModel in
                    guard let self = self else { return }
                    self.currentModel = userModel
                    model = userModel
                    self.semaphore.signal()
                }
                semaphore.wait()
                return model
            }
        }
        set {
            currentModel = newValue
        }
    }
}
