import UIKit

protocol ImageLoaderServiceProtocol {
    func loadImageDataModel(handler: @escaping (ImageDataModels) -> Void)
    func loadImage(urlString: String, handler: @escaping (UIImage?) -> Void)
    func cancelTaskWithUrl(urlString: String)
}

class ImageLoaderService: ImageLoaderServiceProtocol {

    // MARK: - Properties
    let queue = DispatchQueue.global(qos: .utility)

    // MARK: - Dependencies
    var parser: ParserProtocol
    var networkManager: NetworkManagerProtocol

    init(parser: ParserProtocol, networkManager: NetworkManagerProtocol) {
        self.parser = parser
        self.networkManager = networkManager
    }

    func loadImageDataModel(handler: @escaping (ImageDataModels) -> Void) {
        guard var url = URL(string: "https://pixabay.com/api/") else { return }
        let urlParams = [
            "key": networkManager.apiKey,
            "image_type": "photo",
            "per_page": "150",
            "q": "people",
            "pretty": "true"
        ]
        url = url.appendingQueryParameters(urlParams)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        queue.async { [weak self] in
            guard let self = self else { return }
            self.networkManager.getData(request: request) { result in
                switch result {
                case .success(let data):
                    if let imageDataModel = self.parser.decodeData(type: ImageDataModels.self, data: data) {
                        handler(imageDataModel)
                    }

                case .failure(let error):
                    Logger.shared.printLogs(text: "Network data task has been failed: \(error.localizedDescription)")
                }
            }
        }
    }

    func loadImage(urlString: String, handler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)

        queue.async { [weak self] in
            guard let self = self else { return }
            self.networkManager.getData(request: request) { result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    handler(image)

                case .failure(let error):
                    handler(nil)
                    Logger.shared.printLogs(text: "Network data task has been failed: \(error.localizedDescription)")
                }
            }
        }
    }

    func cancelTaskWithUrl(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.getAllTasks { tasks in
            let runningTasks = tasks.filter { $0.state == .running }
            if let task = runningTasks.filter({ $0.originalRequest?.url == url }).first {
                task.cancel()
            }
        }
    }
}
