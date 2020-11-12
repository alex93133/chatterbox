import Foundation

protocol ServicesAssemblyProtocol {
    var userDataService: UserDataServiceProtocol { get }
    var chatDataService: ChatDataServiceProtocol { get }  
    var frcService: FRCServiceProtocol { get }
    var themesService: ThemesServiceProtocol { get }
    var accessCheckerService: AccessCheckerServicePorotocol { get }
}

class ServicesAssembly: ServicesAssemblyProtocol {

    private var coreAssembly: CoreAssemblyProtocol

    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }

    lazy var gcdUserDataService: UserDataProtocol = GCDUserDataService(fileManagerStack: coreAssembly.fileManagerStack)

    lazy var operationUserDataService: UserDataProtocol = OperationUserDataService(fileManagerStack: coreAssembly.fileManagerStack)

    lazy var userDataService: UserDataServiceProtocol = UserDataService(gcdUserDataService: gcdUserDataService, 
                                                                        operationUserDataService: operationUserDataService)
    
    lazy var chatDataService: ChatDataServiceProtocol = ChatDataService(networkManager: coreAssembly.firebaseManager, 
                                                                        storage: coreAssembly.coreDataManager, 
                                                                        userDataService: userDataService)
    
    lazy var frcService: FRCServiceProtocol = FRCService(coreDataStack: coreAssembly.coreDataStack)
    lazy var themesService: ThemesServiceProtocol = ThemesService(userDataService: userDataService)
    lazy var accessCheckerService: AccessCheckerServicePorotocol = AccessCheckerService()
}
