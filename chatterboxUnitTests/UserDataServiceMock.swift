import Foundation
@testable import chatterbox

class UserDataServiceMock: UserDataServiceProtocol {
    var userModel: User = User(photo: nil,
                               name: "User",
                               description: "",
                               theme: .classic,
                               uuID: "UserID")

    func loadUser() {
    }

    func updateModel(user: User, service: SaveService?, handler: @escaping (Result<User, FileManagerError>) -> Void) {
    }

    func createUser(user: User) {
    }
}
