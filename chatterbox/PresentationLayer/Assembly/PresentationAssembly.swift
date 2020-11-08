import Foundation
import CoreData

protocol PresentationAssemblyProtocol {
    func conversationListViewController() -> ConversationsListViewController
    func conversationViewController(with channelDB: ChannelDB) -> ConversationViewController
    func themesViewController(with theme: Theme) -> ThemesViewController
    func profileViewController(with user: User) -> ProfileViewController
}


class PresentationAssembly: PresentationAssemblyProtocol {
   private var serviceAssembly: ServicesAssemblyProtocol
    
    init(serviceAssembly: ServicesAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    
    // MARK: - ConversationsListViewController
    func conversationListViewController() -> ConversationsListViewController {
        let model = ConversationsListModel(userDataService: serviceAssembly.userDataService,
                                           coreDataService: serviceAssembly.coreDataService,
                                           firebaseService: serviceAssembly.firebaseService,
                                           themesService: serviceAssembly.themesService, 
                                           frcService: serviceAssembly.frcService)
        return ConversationsListViewController(model: model, presentationAssembly: self)
    }
    
    // MARK: - ConversationViewController
    func conversationViewController(with channelDB: ChannelDB) -> ConversationViewController {
        let model = ConversationModel(userDataService: serviceAssembly.userDataService, 
                                      coreDataService: serviceAssembly.coreDataService,
                                      firebaseService: serviceAssembly.firebaseService,
                                      themesService: serviceAssembly.themesService, 
                                      frcService: serviceAssembly.frcService,
                                      channelModel: channelDB)
        return ConversationViewController(model: model, presentationAssembly: self)
    }
    
    // MARK: - ThemesViewController
    func themesViewController(with theme: Theme) -> ThemesViewController {
        let model = ThemesModel(userDataService: serviceAssembly.userDataService,
                                themesService: serviceAssembly.themesService, 
                                theme: theme)
        return ThemesViewController(model: model, presentationAssembly: self)
    }
    
    // MARK: - ProfileViewController
    func profileViewController(with user: User) -> ProfileViewController {
        let model = ProfileModel(userDataService: serviceAssembly.userDataService,
                                 themesService: serviceAssembly.themesService,
                                 user: user)
        return ProfileViewController(model: model, presentationAssembly: self)
    }
}
