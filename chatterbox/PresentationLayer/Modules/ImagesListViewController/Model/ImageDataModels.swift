import UIKit

// MARK: - ImageDataModels
struct ImageDataModels: Decodable {
    let imageDataModels: [ImageDataModel]

    private enum CodingKeys: String, CodingKey {
        case imageDataModels = "hits"
    }
}

// MARK: - ImageDataModel
struct ImageDataModel: Decodable {
    let urlString: String
    var image: UIImage?

    private enum CodingKeys: String, CodingKey {
        case urlString = "webformatURL"
    }
}
