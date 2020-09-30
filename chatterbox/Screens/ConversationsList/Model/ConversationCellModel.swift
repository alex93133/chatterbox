import Foundation

struct ConversationCellModel {
    let name: String
    let message: String
    let date: Date
    let isOnline: Bool
    let hasUnreadMessages: Bool

    var dateString: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "dd MMM"
        }
        return formatter.string(from: date)
    }

    var statusString: String {
        let statusString = isOnline ? "Online" : "Offline"
        return NSLocalizedString(statusString, comment: "")
    }
}
