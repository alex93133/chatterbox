import Foundation

protocol ImagesListModelProtocol {
    var themesService: ThemesServiceProtocol { get }
    var imageLoaderService: ImageLoaderServiceProtocol { get }
}

class ImagesListModel: ImagesListModelProtocol {
    var themesService: ThemesServiceProtocol
    var imageLoaderService: ImageLoaderServiceProtocol

    init(themesService: ThemesServiceProtocol,
         imageLoaderService: ImageLoaderServiceProtocol) {
        self.themesService = themesService
        self.imageLoaderService = imageLoaderService
    }
}
