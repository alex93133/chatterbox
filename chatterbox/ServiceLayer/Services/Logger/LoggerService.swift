import Foundation

struct LoggerService {

    static let shared = LoggerService()
    private init() {}

    func printLogs(text: String) {
        #if DEBUG
        print(text)
        #endif
    }
}
