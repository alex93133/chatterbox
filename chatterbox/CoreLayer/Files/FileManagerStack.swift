import Foundation

protocol FileManagerStackProtocol {
    var fileManager: FileManager { get }
    var documentDirectory: URL { get }
}

class FileManagerStack: FileManagerStackProtocol {
    var fileManager = FileManager.default
    var documentDirectory: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
