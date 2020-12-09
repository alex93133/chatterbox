import Foundation

struct InfoPlistParser {
    static func getValue(for key: String) -> String? {
        let value = Bundle.main.infoDictionary?[key] as? String
        return value
    }
}
