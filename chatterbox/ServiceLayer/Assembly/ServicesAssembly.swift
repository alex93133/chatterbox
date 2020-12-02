import Foundation

protocol ServicesAssemblyProtocol {
    var userDataService: UserDataServiceProtocol { get }
    var chatDataService: ChatDataServiceProtocol { get }
    var frcService: FRCServiceProtocol { get }
    var themesService: ThemesServiceProtocol { get }
    var accessCheckerService: AccessCheckerServiceProtocol { get }
    var imageLoaderService: ImageLoaderServiceProtocol { get }
}

class ServicesAssembly: ServicesAssemblyProtocol {

    private var coreAssembly: CoreAssemblyProtocol

    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }

    lazy var gcdUserDataService: UserDataProtocol = GCDUserDataService()
    lazy var operationUserDataService: UserDataProtocol = OperationUserDataService()

    lazy var userDataService: UserDataServiceProtocol = UserDataService(gcdUserDataService: gcdUserDataService,
                                                                        operationUserDataService: operationUserDataService)

    lazy var chatDataService: ChatDataServiceProtocol = ChatDataService(conversationManager: coreAssembly.firebaseManager,
                                                                        storage: coreAssembly.coreDataManager,
                                                                        userDataService: userDataService)

    lazy var imageLoaderService: ImageLoaderServiceProtocol = ImageLoaderService(parser: coreAssembly.parser,
                                                                                 networkManager: coreAssembly.networkManager)

    lazy var frcService: FRCServiceProtocol = FRCService(coreDataStack: coreAssembly.coreDataStack)
    lazy var themesService: ThemesServiceProtocol = ThemesService(userDataService: userDataService)
    lazy var accessCheckerService: AccessCheckerServiceProtocol = AccessCheckerService()
}
