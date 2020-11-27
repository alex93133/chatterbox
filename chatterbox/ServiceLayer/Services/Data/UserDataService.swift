import UIKit

protocol UserDataServiceProtocol {
    func loadUser()
    var userModel: User { get set }
    var dataManager: UserDataProtocol { get set }
    var gcdUserDataService: UserDataProtocol { get set }
    var operationUserDataService: UserDataProtocol { get set }
}

class UserDataService: UserDataServiceProtocol {

    // MARK: - Properties
    private var currentDataManager: UserDataProtocol!
    var dataManager: UserDataProtocol {
        get {
            let randomIndex = Int.random(in: 0...1)
            let managers = [gcdUserDataService, operationUserDataService]
            currentDataManager = managers[randomIndex]
            return currentDataManager
        } set {
            currentDataManager = newValue
        }
    }

    var userModel = User(photo: nil,
                         name: "User",
                         description: "",
                         theme: .classic,
                         uuID: "")

    // MARK: - Dependencies
    var gcdUserDataService: UserDataProtocol
    var operationUserDataService: UserDataProtocol

    init(gcdUserDataService: UserDataProtocol, operationUserDataService: UserDataProtocol) {
        self.gcdUserDataService = gcdUserDataService
        self.operationUserDataService = operationUserDataService
    }

    // MARK: - Functions
    func loadUser() {
        dataManager.getUserModel { [weak self] model in
            guard let self = self,
                  let model = model else { return }
            self.userModel = model
        }
    }
}
