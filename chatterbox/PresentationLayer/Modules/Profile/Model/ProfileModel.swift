import Foundation

protocol ProfileModelProtocol {
    var userDataService: UserDataServiceProtocol { get set }
    var themesService: ThemesServiceProtocol { get }
    var user: User { get }
}

class ProfileModel: ProfileModelProtocol {
    var userDataService: UserDataServiceProtocol
    var themesService: ThemesServiceProtocol
    var user: User

    init(userDataService: UserDataServiceProtocol,
         themesService: ThemesServiceProtocol,
         user: User) {
        self.userDataService = userDataService
        self.themesService = themesService
        self.user = user
    }
}
