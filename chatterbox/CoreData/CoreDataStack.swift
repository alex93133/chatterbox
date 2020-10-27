import Foundation
import CoreData

class CoreDataStack {
    
    // MARK: - Properties
    var didUpdateDataBase: ((CoreDataStack) -> Void)?
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    let queue = DispatchQueue.global(qos: .background)
    
    private var storeURL: URL = {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory,
                                                         in: .userDomainMask).last
            else { fatalError("Document path is not founded") }
        return documentURL.appendingPathComponent("Chat.sqlite")
    }()
    
    // MARK: - Init Stack
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let  modelURL = Bundle.main.url(forResource: dataModelName,
                                              withExtension: dataModelExtension)
            else { fatalError("Model path is not founded") }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            else { fatalError("ManagedObjectModel can't be created") }
        
        return managedObjectModel
    }()
    
    private lazy var persistantStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        queue.async {
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: self.storeURL,
                                                   options: nil)
            } catch {
                fatalError("Peristant store coordinator error: \(error.localizedDescription)")
            }
        }
        
        return coordinator
    }()
    
    // MARK: - Contexts
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistantStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private lazy var saveContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    // MARK: - Save Context
    func performSave(_ handler: (NSManagedObjectContext) -> Void) {
        let context = saveContext
        context.performAndWait {
            handler(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent {
            performSave(in: parent)
        }
    }
    
    // MARK: - Observers
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChanged(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc
    private func managedObjectContextObjectsDidChanged(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        didUpdateDataBase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            inserts.count > 0 {
            print("Inserted objects count: \(inserts.count)")
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
            updates.count > 0 {
            print("Updates objects count: \(updates.count)")
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
            deletes.count > 0 {
            print("Deleted objects count: \(deletes.count)")
        }
    }
    
    // MARK: - Statistics
    func printDataBaseStatistics() {
        mainContext.perform {
            do {
                let channelsCount = try self.mainContext.count(for: ChannelDB.fetchRequest())
                let messagesCount = try self.mainContext.count(for: MessageDB.fetchRequest())
                Logger.shared.printLogs(text: "Channels count: \(channelsCount)" + "\n" + "Total messages count: \(messagesCount)")
            } catch {
                fatalError("Unable to get database statistics: \(error.localizedDescription)")
            }
        }
    }
}
