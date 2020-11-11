import Foundation

struct MessageCellModel {

    // MARK: - Properties
    let message: MessageDB
    var isIncoming: Bool {
        return userDataService.userModel.uuID != message.senderId
    }

    // MARK: - Dependencies
    var userDataService: UserDataServiceProtocol

}
