import Foundation

protocol ConversationsListModelProtocol {
    var userDataService: UserDataServiceProtocol { get }
    var coreDataService: CoreDataServiceProtocol { get }
    var firebaseService: FirebaseServiceProtocol { get }
    var themesService: ThemesServiceProtocol { get }
    var frcService: FRCServiceProtocol { get }
}


class ConversationsListModel: ConversationsListModelProtocol {
    var userDataService: UserDataServiceProtocol
    var coreDataService: CoreDataServiceProtocol
    var firebaseService: FirebaseServiceProtocol
    var themesService: ThemesServiceProtocol
    var frcService: FRCServiceProtocol
    
    init(userDataService: UserDataServiceProtocol,
         coreDataService: CoreDataServiceProtocol,
         firebaseService: FirebaseServiceProtocol,
         themesService: ThemesServiceProtocol,
         frcService: FRCServiceProtocol) {
        self.userDataService = userDataService
        self.coreDataService = coreDataService
        self.firebaseService = firebaseService
        self.themesService = themesService
        self.frcService = frcService
    }
}
