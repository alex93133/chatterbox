import Foundation

protocol ChatDataServiceProtocol {
    func getChannels()
    func getMessages(identifier: String)
    func sendMessage(content: String, identifier: String)
    func createChannel(name: String)
    func deleteChannel(identifier: String)
}

class ChatDataService: ChatDataServiceProtocol {
    
    // MARK: - Dependencies
    var networkManager: NetworkManagerProtocol
    var storage: StorageProtocol
    var userDataService: UserDataServiceProtocol
    
    init(networkManager: NetworkManagerProtocol, storage: StorageProtocol, userDataService: UserDataServiceProtocol) {
        self.networkManager = networkManager
        self.storage = storage
        self.userDataService = userDataService
    }
    
    func getChannels() {
        networkManager.getChannels { [weak self] dicionarry in
            guard let self = self else { return }    
            if let channelsToSave = dicionarry["save"] {
                self.storage.saveChannelsToDB(channelsToSave)
            }
            
            if let channelsToUpdate = dicionarry["update"] {
                self.storage.updateChannelsInDB(channelsToUpdate)
            }
            
            if let channelsToDelete = dicionarry["delete"] {
                self.storage.deleteChannelsFromDB(channelsToDelete)
            }
        }
    }
    
    func getMessages(identifier: String) {
        networkManager.getMessages(identifier: identifier) { [weak self] messages in
            guard let self = self else { return }
            self.storage.saveMessagesToDB(channelID: identifier, messages: messages)
        }
    }
    
    func sendMessage(content: String, identifier: String) {
        let user = userDataService.userModel
        networkManager.sendMessage(sender: user, content: content, identifier: identifier)
    }

    func createChannel(name: String) {
        networkManager.createChannel(name: name)
    }

    func deleteChannel(identifier: String) {
        networkManager.deleteChannel(identifier: identifier)
    }
}
