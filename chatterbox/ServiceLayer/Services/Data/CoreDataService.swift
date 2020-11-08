import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func saveChannelsToDB(_ channels: [Channel])
    func deleteChannelsFromDB(_ channels: [Channel])
    func updateChannelsInDB(_ channels: [Channel])
    func saveMessagesToDB(channelID: String, messages: [Message])
    func enableStatisticts()
}

class CoreDataService: CoreDataServiceProtocol {
    
    
    // MARK: - Dependencies
    var coreDataStack: CoreDataStackProtocol
    
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Functions
    func saveChannelsToDB(_ channels: [Channel]) {
        coreDataStack.performSave { context in
            channels.forEach { channel in
                let predicate = NSPredicate(format: "identifier == %@", channel.identifier)
                guard objectIsNotExist(type: ChannelDB.self, predicate: predicate, context: context) else { return }
                _ = ChannelDB(channel: channel, in: context)
            }
        }
    }
    
    func deleteChannelsFromDB(_ channels: [Channel]) {
        coreDataStack.performSave { context in
            channels.forEach { channel in
                if let channelDB = getChannel(for: channel.identifier, in: context) {
                    context.delete(channelDB)
                }
            }
        }
    }
    
    func updateChannelsInDB(_ channels: [Channel]) {
        coreDataStack.performSave { context in
            channels.forEach { channel in
                if let channelDB = getChannel(for: channel.identifier, in: context) {
                    channelDB.lastMessage = channel.lastMessage
                    channelDB.lastActivity = channel.lastActivity
                }
            }
        }
    }
    
    private func getChannel(for identifier: String, in context: NSManagedObjectContext) -> ChannelDB? {
        let fetchRequest: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        let results = try? context.fetch(fetchRequest)
        return results?.first
    }
    
    func saveMessagesToDB(channelID: String, messages: [Message]) {
        coreDataStack.performSave { context in
            if let channelDB = getChannel(for: channelID, in: context) {
                messages.forEach { message in
                    let predicate = NSPredicate(format: "identifier == %@", message.identifier)
                    guard objectIsNotExist(type: MessageDB.self, predicate: predicate, context: context) else { return }
                    let messageDB = MessageDB(message: message, in: context)
                    channelDB.addToMessages(messageDB)
                }
            }
        }
    }
    
    private func objectIsNotExist<Object: NSManagedObject>(type: Object.Type, predicate: NSPredicate, context: NSManagedObjectContext) -> Bool {
        let fetchRequest = type.fetchRequest()
        fetchRequest.predicate = predicate
        if let results = try? context.fetch(fetchRequest),
           results.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func enableStatisticts() {
        coreDataStack.observeStatistics()
    }
}
