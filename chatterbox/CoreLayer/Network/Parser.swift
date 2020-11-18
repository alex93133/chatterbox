import Foundation

protocol ParserProtocol {
    func decodeData<T: Decodable>(type: T.Type, data: Data?) -> T?
}

class Parser: ParserProtocol {
    func decodeData<T: Decodable>(type: T.Type, data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else { return nil }
        do {
            let parsedJSON = try decoder.decode(type.self, from: data)
            return parsedJSON
        } catch let decodeError {
            Logger.shared.printLogs(text: "Decoding error: \(decodeError)")
            return nil
        }
    }
}
