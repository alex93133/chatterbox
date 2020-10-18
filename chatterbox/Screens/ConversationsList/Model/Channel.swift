import Foundation
import Firebase

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

extension Channel {
    init?(data: [String: Any], documentID: String) {
        guard let name = data["name"] as? String else { return nil }
        let timestamp = data["lastActivity"] as? Timestamp

        self.identifier = documentID
        self.name = name
        self.lastMessage = data["lastMessage"] as? String
        self.lastActivity = timestamp?.dateValue()
    }
}
