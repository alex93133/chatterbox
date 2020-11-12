import Foundation

protocol CoreAssemblyProtocol {
    var coreDataManager: StorageProtocol { get }
    var coreDataStack: CoreDataStackProtocol { get }
    var fileManagerStack: FileManagerStackProtocol { get }
    var firebaseManager: NetworkManagerProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    lazy var firebaseManager: NetworkManagerProtocol = FirebaseManager()
    lazy var coreDataManager: StorageProtocol = CoreDataManager(coreDataStack: coreDataStack)
    lazy var coreDataStack: CoreDataStackProtocol = CoreDataStack()
    lazy var fileManagerStack: FileManagerStackProtocol = FileManagerStack()
}
