import UIKit

class UserManager {

    static let shared = UserManager()
    private init() {}

    private var gcdManager: DataManager = GCDDataManager()
    private var operationManager: DataManager = OperationDataManager()
    private var currentDataManager: DataManager!
    var dataManager: DataManager {
        get {
            let randomIndex = Int.random(in: 0...1)
            let managers = [gcdManager, operationManager]
            currentDataManager = managers[randomIndex]
            return currentDataManager
        } set {
            currentDataManager = newValue
        }
    }

    var userModel = UserModel(photo: nil,
                              name: "User",
                              description: "",
                              theme: .classic,
                              uuID: "")

    func loadUser() {
        dataManager.getUserModel { [weak self] model in
            guard let self = self,
                let model = model else { return }
            self.userModel = model
        }
    }
}
