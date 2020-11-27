import Foundation
import CoreData

protocol FRCServiceProtocol {
    func getFRC<Object: NSManagedObject>(fetchRequest: NSFetchRequest<Object>,
                                         sectionNameKeyPath: String?,
                                         cacheName: String?) -> NSFetchedResultsController<Object>
}

class FRCService: FRCServiceProtocol {

    // MARK: - Dependencies
    var coreDataStack: CoreDataStackProtocol

    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }

    func getFRC<Object: NSManagedObject>(fetchRequest: NSFetchRequest<Object>,
                                         sectionNameKeyPath: String?,
                                         cacheName: String?) -> NSFetchedResultsController<Object> {
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: coreDataStack.viewContext,
                                          sectionNameKeyPath: sectionNameKeyPath,
                                          cacheName: cacheName)
    }
}
