import UIKit

protocol NetworkManagerProtocol {
    func getData(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void)
    var apiKey: String { get }
}

class NetworkManager: NetworkManagerProtocol {

    let apiKey = InfoPlistParser.getValue(for: "API_KEY") ?? ""

    func getData(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error -> Void in

            if let httpResponse = response as? HTTPURLResponse,
               !(200..<300 ~= httpResponse.statusCode) {
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
                handler(.failure(error))
            }

            if let error = error {
                handler(.failure(error))
                return
            }

            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary: URLQueryParameterStringConvertible {
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
}

extension URL {
    func appendingQueryParameters(_ parametersDictionary: [String: String]) -> URL {
        let URLString: String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
