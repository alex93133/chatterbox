import Foundation

struct MessageCellModel {
    let message: MessageDB
    var isIncoming: Bool {
        return UserDataService.shared.userModel.uuID != message.senderId
    }
}
