import Foundation

struct MessageCellModel {
    let message: MessageDB
    var isIncoming: Bool {
        return UserManager.shared.userModel.uuID != message.senderId
    }
}
