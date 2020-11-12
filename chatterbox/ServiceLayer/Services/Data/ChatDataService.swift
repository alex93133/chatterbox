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
    var conversationManager: ConversationManagerProtocol
    var storage: StorageProtocol
    var userDataService: UserDataServiceProtocol

    init(networkManager: ConversationManagerProtocol, storage: StorageProtocol, userDataService: UserDataServiceProtocol) {
        self.conversationManager = networkManager
        self.storage = storage
        self.userDataService = userDataService
    }

    func getChannels() {
        conversationManager.getChannels { [weak self] dictionary in
            guard let self = self else { return }
            if let channelsToSave = dictionary["save"] {
                self.storage.saveChannelsToDB(channelsToSave)
            }

            if let channelsToUpdate = dictionary["update"] {
                self.storage.updateChannelsInDB(channelsToUpdate)
            }

            if let channelsToDelete = dictionary["delete"] {
                self.storage.deleteChannelsFromDB(channelsToDelete)
            }
        }
    }

    func getMessages(identifier: String) {
        conversationManager.getMessages(identifier: identifier) { [weak self] messages in
            guard let self = self else { return }
            self.storage.saveMessagesToDB(channelID: identifier, messages: messages)
        }
    }

    func sendMessage(content: String, identifier: String) {
        let user = userDataService.userModel
        conversationManager.sendMessage(sender: user, content: content, identifier: identifier)
    }

    func createChannel(name: String) {
        conversationManager.createChannel(name: name)
    }

    func deleteChannel(identifier: String) {
        conversationManager.deleteChannel(identifier: identifier)
    }
}
