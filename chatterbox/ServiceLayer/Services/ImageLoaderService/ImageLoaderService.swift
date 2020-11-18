import UIKit

protocol ImageLoaderServiceProtocol {
    func loadImageDataModel(handler: @escaping (ImageDataModels) -> Void)
    func loadImage(urlString: String, handler: @escaping (UIImage) -> Void)
}

class ImageLoaderService: ImageLoaderServiceProtocol {

    // MARK: - Properties
    let queue = DispatchQueue.global(qos: .default)

    // MARK: - Dependencies
    var parser: ParserProtocol
    var networkManager: NetworkManagerProtocol

    init(parser: ParserProtocol, networkManager: NetworkManagerProtocol) {
        self.parser = parser
        self.networkManager = networkManager
    }

    func loadImageDataModel(handler: @escaping (ImageDataModels) -> Void) {
        guard var url = URL(string: "https://pixabay.com/api/") else { return }
        let URLParams = [
            "key": networkManager.apiKey,
            "image_type": "photo",
            "per_page": "30",
            "q": "people",
            "pretty": "true"
        ]
        url = url.appendingQueryParameters(URLParams)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        queue.async { [weak self] in
            guard let self = self else { return }
            self.networkManager.getData(request: request) { result in
                switch result {
                case .success(let data):
                    if let imageDataModel = self.parser.decodeData(type: ImageDataModels.self, data: data) {
                        DispatchQueue.main.async {
                            handler(imageDataModel)
                        }
                    }

                case .failure(let error):
                    Logger.shared.printLogs(text: "Network data task has been failed: \(error.localizedDescription)")
                }
            }
        }
    }

    func loadImage(urlString: String, handler: @escaping (UIImage) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)

        queue.async { [weak self] in
            guard let self = self else { return }
            self.networkManager.getData(request: request) { result in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            handler(image)
                        }
                    }

                case .failure(let error):
                    Logger.shared.printLogs(text: "Network data task has been failed: \(error.localizedDescription)")
                }
            }
        }
    }
}
