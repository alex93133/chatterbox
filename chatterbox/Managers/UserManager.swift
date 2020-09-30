import UIKit

struct UserManager {

    static let shared = UserManager()
    private init() {}

    var currentUserModel = ProfileModel(photo: nil,
                                        name: "Alexander Lazarev",
                                        description: "Junior iOS Developer")
}
