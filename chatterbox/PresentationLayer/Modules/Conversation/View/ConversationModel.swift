import Foundation

protocol ConversationModelProtocol {
    var userDataService: UserDataServiceProtocol { get }
    var coreDataService: CoreDataServiceProtocol { get }
    var firebaseService: FirebaseServiceProtocol { get }
    var themesService: ThemesServiceProtocol { get }
    var frcService: FRCServiceProtocol { get }
    var channelModel: ChannelDB { get }
}

class ConversationModel: ConversationModelProtocol {
    
    var userDataService: UserDataServiceProtocol
    var coreDataService: CoreDataServiceProtocol
    var firebaseService: FirebaseServiceProtocol
    var themesService: ThemesServiceProtocol
    var frcService: FRCServiceProtocol
    var channelModel: ChannelDB
    
    init(userDataService: UserDataServiceProtocol,
        coreDataService: CoreDataServiceProtocol,
         firebaseService: FirebaseServiceProtocol,
         themesService: ThemesServiceProtocol,
         frcService: FRCServiceProtocol,
         channelModel: ChannelDB) {
        self.userDataService = userDataService
        self.coreDataService = coreDataService
        self.firebaseService = firebaseService
        self.themesService = themesService
        self.frcService = frcService
        self.channelModel = channelModel
    }
}
