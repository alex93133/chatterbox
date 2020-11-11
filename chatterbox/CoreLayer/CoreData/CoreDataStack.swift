import Foundation
import CoreData

protocol CoreDataStackProtocol {
    var viewContext: NSManagedObjectContext { get }
    func performSave(_ handler: (NSManagedObjectContext) -> Void)
    func observeStatistics()
}

class CoreDataStack: CoreDataStackProtocol {

    // MARK: - Properties
    private let dataModelName = "Chat"
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Container creation error: \(error) \(error.userInfo)")
            }
        }
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    // MARK: - Save Context
    func performSave(_ handler: (NSManagedObjectContext) -> Void) {
        viewContext.mergePolicy = NSOverwriteMergePolicy
        handler(viewContext)
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                printDataBaseStatistics()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }

    // MARK: - Observers
    func observeStatistics() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChanged(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: container.viewContext)
    }

    @objc
    private func managedObjectContextObjectsDidChanged(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
           inserts.count > 0 {
            Logger.shared.printLogs(text: "Inserted objects count: \(inserts.count)")
        }

        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
           updates.count > 0 {
            Logger.shared.printLogs(text: "Updates objects count: \(updates.count)")
        }

        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
           deletes.count > 0 {
            Logger.shared.printLogs(text: "Deleted objects count: \(deletes.count)")
        }
    }

    // MARK: - Statistics
    func printDataBaseStatistics() {
        container.viewContext.perform {
            do {
                let channelsCount = try self.container.viewContext.count(for: ChannelDB.fetchRequest())
                let messagesCount = try self.container.viewContext.count(for: MessageDB.fetchRequest())
                Logger.shared.printLogs(text: "Channels count: \(channelsCount)" + "\n" + "Total messages count: \(messagesCount)")
            } catch {
                fatalError("Unable to get database statistics: \(error.localizedDescription)")
            }
        }
    }
}
