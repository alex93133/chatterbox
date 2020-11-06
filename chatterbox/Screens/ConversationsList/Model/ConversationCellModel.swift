import Foundation

struct ConversationCellModel {
    var channel: ChannelDB

    var dateString: String? {
        guard let lastActivity = channel.lastActivity else { return nil }
        let formatter = DateFormatter()
        let calendar = Calendar.current
        if calendar.isDateInToday(lastActivity) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "dd MMM"
        }
        return formatter.string(from: lastActivity)
    }
}
