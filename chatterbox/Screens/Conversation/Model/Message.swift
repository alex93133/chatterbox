import Foundation
import Firebase

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String

    func convertToFirebaseData() -> [String: Any] {
        let dictionary: [String: Any] = [ "content": content,
                                          "created": Timestamp(date: created),
                                          "senderId": senderId,
                                          "senderName": senderName ]
        return dictionary
    }
}

extension Message {
    init?(data: [String: Any]) {
        guard let content = data["content"] as? String,
            let timestamp = data["created"] as? Timestamp,
            let senderId = data["senderId"] as? String,
            let senderName = data["senderName"] as? String
            else { return nil }

        self.content = content
        self.created = timestamp.dateValue()
        self.senderId = senderId
        self.senderName = senderName
    }
}
