import Foundation

class RootAssembly {
    lazy var presentationAssembly: PresentationAssemblyProtocol = PresentationAssembly(serviceAssembly: servicesAssembly)
    lazy var servicesAssembly: ServicesAssemblyProtocol = ServicesAssembly(coreAssembly: coreAssembly)
    private lazy var coreAssembly: CoreAssemblyProtocol = CoreAssembly()
}
