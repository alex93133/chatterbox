import Foundation
import Firebase

struct Message: Equatable {
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

extension Message {
    init?(data: [String: Any], documentID: String) {
        guard let content = data["content"] as? String,
              let timestamp = data["created"] as? Timestamp,
              let senderId = data["senderId"] as? String,
              let senderName = data["senderName"] as? String
        else { return nil }

        self.identifier = documentID
        self.content = content
        self.created = timestamp.dateValue()
        self.senderId = senderId
        self.senderName = senderName
    }
}
