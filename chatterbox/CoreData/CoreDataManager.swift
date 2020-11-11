import Foundation
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()
    private init() {}

    // MARK: - Properties
    let coreDataStack = CoreDataStack()

    // MARK: - Functions
    func saveChannelsToDB(channels: [Channel]) {
        coreDataStack.performSave { context in
            _ = channels.map { ChannelDB(channel: $0, in: context) }
        }
    }

    func saveMessagesToDB(channelID: String, messages: [Message]) {
        coreDataStack.performSave { context in
            let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier = '\(channelID)'")
            let results = try? context.fetch(fetchRequest)
            if let channel = results?.first {
                let messagesDB = messages.map { MessageDB(message: $0, in: context) }
                messagesDB.forEach { channel.addToMessages($0) }
            }
        }
    }
}
