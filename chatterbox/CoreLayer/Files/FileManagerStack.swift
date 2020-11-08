import Foundation

protocol FileManagerStackProtocol {
    var documentDirectory: URL { get }
}

class FileManagerStack: FileManagerStackProtocol {
    var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}
