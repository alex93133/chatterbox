import Foundation

class Logger {
    
    static let shared = Logger()
    private init() {}

    func printLogs(text: String) {
        #if DEBUG
        print(text)
        #endif
    }
}
