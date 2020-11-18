import Foundation

protocol CoreAssemblyProtocol {
    var coreDataManager: StorageProtocol { get }
    var coreDataStack: CoreDataStackProtocol { get }
    var fileManagerStack: FileManagerStackProtocol { get }
    var firebaseManager: ConversationManagerProtocol { get }
    var networkManager: NetworkManagerProtocol { get }
    var parser: ParserProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    lazy var firebaseManager: ConversationManagerProtocol = FirebaseManager()
    lazy var coreDataManager: StorageProtocol = CoreDataManager(coreDataStack: coreDataStack)
    lazy var coreDataStack: CoreDataStackProtocol = CoreDataStack()
    lazy var fileManagerStack: FileManagerStackProtocol = FileManagerStack()
    lazy var networkManager: NetworkManagerProtocol = NetworkManager()
    lazy var parser: ParserProtocol = Parser()
}
