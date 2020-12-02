import UIKit

enum SaveService {
    case gcd
    case operation
}

protocol UserDataServiceProtocol {
    var userModel: User { get set }
    func loadUser()
    func updateModel(user: User, service: SaveService?, handler: @escaping (Result<User, FileManagerError>) -> Void)
    func createUser(user: User)
}

class UserDataService: UserDataServiceProtocol {

    // MARK: - Properties
    private var currentDataManager: UserDataProtocol!
    private var dataManager: UserDataProtocol {
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
    private var gcdUserDataService: UserDataProtocol
    private var operationUserDataService: UserDataProtocol

    init(gcdUserDataService: UserDataProtocol, operationUserDataService: UserDataProtocol) {
        self.gcdUserDataService = gcdUserDataService
        self.operationUserDataService = operationUserDataService
    }

    // MARK: - Functions
    func createUser(user: User) {
        dataManager.createUser(user)
    }

    func loadUser() {
        dataManager.getUserModel { [weak self] model in
            guard let self = self,
                  let model = model else { return }
            self.userModel = model
        }
    }

    func updateModel(user: User, service: SaveService?, handler: @escaping (Result<User, FileManagerError>) -> Void) {
        switch service {
        case .gcd:
            dataManager = gcdUserDataService

        case .operation:
            dataManager = operationUserDataService

        case .none:
            break
        }

        dataManager.updateModel(with: user) { result in
            handler(result)
        }
    }
}
