import Foundation

protocol ConversationsListModelProtocol {
    var userDataService: UserDataServiceProtocol { get }
    var chatDataService: ChatDataServiceProtocol { get }
    var themesService: ThemesServiceProtocol { get }
    var frcService: FRCServiceProtocol { get }
}

class ConversationsListModel: ConversationsListModelProtocol {
    var userDataService: UserDataServiceProtocol
    var chatDataService: ChatDataServiceProtocol
    var themesService: ThemesServiceProtocol
    var frcService: FRCServiceProtocol

    init(userDataService: UserDataServiceProtocol,
         chatDataService: ChatDataServiceProtocol,
         themesService: ThemesServiceProtocol,
         frcService: FRCServiceProtocol) {
        self.userDataService = userDataService
        self.chatDataService = chatDataService
        self.themesService = themesService
        self.frcService = frcService
    }
}
