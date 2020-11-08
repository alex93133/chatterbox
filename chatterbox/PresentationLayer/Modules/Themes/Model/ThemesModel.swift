import Foundation

protocol ThemesModelProtocol {
    var userDataService: UserDataServiceProtocol { get }
    var themesService: ThemesServiceProtocol { get }
    var theme: Theme { get }
}


class ThemesModel: ThemesModelProtocol {
    var userDataService: UserDataServiceProtocol
    var themesService: ThemesServiceProtocol
    var theme: Theme
    
    init(userDataService: UserDataServiceProtocol,
         themesService: ThemesServiceProtocol,
         theme: Theme) {
        self.userDataService = userDataService
        self.themesService = themesService
        self.theme = theme
    }
}
