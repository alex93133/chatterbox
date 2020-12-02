import Foundation

class RootAssembly {
    lazy var presentationAssembly: PresentationAssemblyProtocol = PresentationAssembly(serviceAssembly: servicesAssembly)
    private lazy var servicesAssembly: ServicesAssemblyProtocol = ServicesAssembly(coreAssembly: coreAssembly)
    private lazy var coreAssembly: CoreAssemblyProtocol = CoreAssembly()
}

protocol AppLoadingProtocol {
    func createDefaultUser()
    func loadUser()
}

extension RootAssembly: AppLoadingProtocol {
    func createDefaultUser() {
        let uuid = UUID().uuidString
        let user = User(photo: nil,
                        name: "Alexander Lazarev",
                        description: "Junior iOS dev",
                        theme: .classic,
                        uuID: uuid)
        servicesAssembly.userDataService.createUser(user: user)
    }

    func loadUser() {
        servicesAssembly.userDataService.loadUser()
    }
}
