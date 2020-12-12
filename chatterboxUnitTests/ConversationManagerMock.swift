import Foundation
@testable import chatterbox

class ConversationManagerMock: ConversationManagerProtocol {
    var callCounter = 0

    var identifier: String!
    var name: String!
    var sender: User!
    var content: String!

    var channelsStub: [String: [Channel]] {
        let deleteChannel = Channel(identifier: "ID",
                                    name: "Test",
                                    lastMessage: nil,
                                    lastActivity: nil)
        let saveChannel = Channel(identifier: "ID2",
                                  name: "Test2",
                                  lastMessage: nil,
                                  lastActivity: nil)
        let updateChannel = Channel(identifier: "ID3",
                                    name: "Test3",
                                    lastMessage: nil,
                                    lastActivity: nil)

        let dictionary = ["save": [saveChannel],
                          "update": [updateChannel],
                          "delete": [deleteChannel],
                          "wrong": []]

        return dictionary
    }
    var messagesStub: [Message] {
        let message = Message(identifier: "Message id",
                              content: "Hello",
                              created: Date(timeIntervalSince1970: 0),
                              senderId: "Sender id",
                              senderName: "Alex")
        return [message]
    }

    func getChannels(handler: @escaping ([String: [Channel]]) -> Void) {
        callCounter += 1
        handler(channelsStub)
    }

    func getMessages(identifier: String, handler: @escaping ([Message]) -> Void) {
        callCounter += 1
        self.identifier = identifier
        handler(messagesStub)
    }

    func sendMessage(sender: User, content: String, identifier: String) {
        callCounter += 1

        self.sender = sender
        self.content = content
        self.identifier = identifier
    }

    func createChannel(name: String) {
        callCounter += 1
        self.name = name
    }

    func deleteChannel(identifier: String) {
        callCounter += 1
        self.identifier = identifier
    }
}
