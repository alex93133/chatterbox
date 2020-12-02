@testable import chatterbox
import XCTest

class chatterboxUnitTests: XCTestCase {

    private var chatDataService: ChatDataServiceProtocol!

    override class func setUp() {
        super.setUp()

//        let conversationManagerMock = ConversationManagerMock()
//        let storageMock = StorageMock()
//        let userDataServiceMock = UserDataServiceMock()
//
//
//        chatDataService = ChatDataService(conversationManager: conversationManagerMock,
//                                              storage: storageMock,
//                                              userDataService: userDataServiceMock)
    }
}

class ConversationManagerMock: ConversationManagerProtocol {
    func getChannels(handler: @escaping ([String : [Channel]]) -> Void) {

    }

    func getMessages(identifier: String, handler: @escaping ([Message]) -> Void) {

    }

    func sendMessage(sender: User, content: String, identifier: String) {

    }

    func createChannel(name: String) {

    }

    func deleteChannel(identifier: String) {

    }
}

class StorageMock: StorageProtocol {
    func saveChannelsToDB(_ channels: [Channel]) {

    }

    func deleteChannelsFromDB(_ channels: [Channel]) {

    }

    func updateChannelsInDB(_ channels: [Channel]) {

    }

    func saveMessagesToDB(channelID: String, messages: [Message]) {

    }
}
