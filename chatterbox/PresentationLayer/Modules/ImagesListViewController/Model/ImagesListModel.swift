import Foundation

protocol ImagesListModelProtocol {
    var themesService: ThemesServiceProtocol { get }
}

class ImagesListModel: ImagesListModelProtocol {
    var themesService: ThemesServiceProtocol
    
    init(themesService: ThemesServiceProtocol) {
        self.themesService = themesService
    }
}
