import Foundation

protocol ConversationModelProtocol {
    var userDataService: UserDataServiceProtocol { get }
    var chatDataService: ChatDataServiceProtocol { get }
    var themesService: ThemesServiceProtocol { get }
    var frcService: FRCServiceProtocol { get }
    var channelModel: ChannelDB { get }
}

class ConversationModel: ConversationModelProtocol {

    var userDataService: UserDataServiceProtocol
    var chatDataService: ChatDataServiceProtocol
    var themesService: ThemesServiceProtocol
    var frcService: FRCServiceProtocol
    var channelModel: ChannelDB

    init(userDataService: UserDataServiceProtocol,
         chatDataService: ChatDataServiceProtocol,
         themesService: ThemesServiceProtocol,
         frcService: FRCServiceProtocol,
         channelModel: ChannelDB) {
        self.userDataService = userDataService
        self.chatDataService = chatDataService
        self.themesService = themesService
        self.frcService = frcService
        self.channelModel = channelModel
    }
}
