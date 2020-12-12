import Foundation
import Firebase

struct Channel: Equatable {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

extension Channel {
    init?(data: [String: Any], documentID: String) {
        guard let name = data["name"] as? String else { return nil }
        let timestamp = data["lastActivity"] as? Timestamp
        let lastMessage = data["lastMessage"] as? String

        // Validate wrong crated channels
        if (timestamp != nil && lastMessage == nil) || (timestamp == nil && lastMessage != nil) {
            return nil
        }

        self.identifier = documentID
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = timestamp?.dateValue()
    }
}
