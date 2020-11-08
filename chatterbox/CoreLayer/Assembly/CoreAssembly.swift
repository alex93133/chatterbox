import Foundation

protocol CoreAssemblyProtocol {
    var coreDataStck: CoreDataStackProtocol { get }
    var fileManagerStack: FileManagerStackProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    lazy var coreDataStck: CoreDataStackProtocol = CoreDataStack()
    lazy var fileManagerStack: FileManagerStackProtocol = FileManagerStack()
}
