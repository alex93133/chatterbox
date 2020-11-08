import UIKit

class UserDataService {

    static let shared = UserDataService()
    private init() {}

    // MARK: - Proprties
    private lazy var gcdManager: UserDataProtocol = GCDUserDataService()
    private lazy var operationManager: UserDataProtocol = OperationUserDataService()
    private var currentDataManager: UserDataProtocol!
    var dataManager: UserDataProtocol {
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

    // MARK: - Functions
    func loadUser() {
        dataManager.getUserModel { [weak self] model in
            guard let self = self,
                  let model = model else { return }
            self.userModel = model
        }
    }
}
