import Foundation

protocol ServicesAssemblyProtocol {
    var userDataService: UserDataServiceProtocol { get }
    var coreDataService: CoreDataServiceProtocol { get }
    var frcService: FRCServiceProtocol { get }
    var firebaseService: FirebaseServiceProtocol { get }
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

    lazy var userDataService: UserDataServiceProtocol = {
        var userDataService: UserDataServiceProtocol = UserDataService.shared
        userDataService.gcdUserDataService = gcdUserDataService
        userDataService.operationUserDataService = operationUserDataService
        return userDataService
    }()

    lazy var firebaseService: FirebaseServiceProtocol = FirebaseService(coreDataService: coreDataService,
                                                                        userDataService: userDataService)

    lazy var coreDataService: CoreDataServiceProtocol = CoreDataService(coreDataStack: coreAssembly.coreDataStck)
    lazy var frcService: FRCServiceProtocol = FRCService(coreDataStack: coreAssembly.coreDataStck)
    lazy var themesService: ThemesServiceProtocol = ThemesService(userDataService: userDataService)
    lazy var accessCheckerService: AccessCheckerServicePorotocol = AccessCheckerService()
}
