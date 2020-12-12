@testable import chatterbox
import XCTest

class СhatterboxUnitTests: XCTestCase {

    // MARK: - Service to test
    private var chatDataService: ChatDataServiceProtocol!

    // MARK: - Dependencies
    var conversationManagerMock: ConversationManagerMock!
    var storageMock: StorageMock!
    var userDataServiceMock: UserDataServiceMock!

    // MARK: - Setup environment
    override func setUp() {
        super.setUp()

        conversationManagerMock = ConversationManagerMock()
        storageMock = StorageMock()
        userDataServiceMock = UserDataServiceMock()

        chatDataService = ChatDataService(conversationManager: conversationManagerMock,
                                          storage: storageMock,
                                          userDataService: userDataServiceMock)

    }

    override func tearDown() {
        chatDataService = nil

        super.tearDown()
    }

    // MARK: - Tests
    func testDeleteChannel() throws {
        // Arrange
        let identifier = "Some id"

        // Act
        chatDataService.deleteChannel(identifier: identifier)

        // Assert
        XCTAssertEqual(conversationManagerMock.callCounter, 1)
        XCTAssertEqual(conversationManagerMock.identifier, identifier)
    }

    func testCreateChannel() throws {
        // Arrange
        let name = "Chat name"

        // Act
        chatDataService.createChannel(name: name)

        // Assert
        XCTAssertEqual(conversationManagerMock.callCounter, 1)
        XCTAssertEqual(conversationManagerMock.name, name)
    }

    func testSendMessage() throws {
        // Arrange
        let content = "Hello"
        let identifier = "Some id"
        let sender = userDataServiceMock.userModel

        // Act
        chatDataService.sendMessage(content: content, identifier: identifier)

        // Assert

        XCTAssertEqual(conversationManagerMock.callCounter, 1)
        XCTAssertEqual(conversationManagerMock.content, content)
        XCTAssertEqual(conversationManagerMock.identifier, identifier)
        XCTAssertEqual(conversationManagerMock.sender, sender)
    }

    func testGetMessages() throws {
        // Arrange
        let identifier = "Some id"

        // Act
        chatDataService.getMessages(identifier: identifier)

        // Assert
        XCTAssertEqual(conversationManagerMock.callCounter, 1)
        XCTAssertEqual(conversationManagerMock.identifier, identifier)

        XCTAssertEqual(storageMock.callCounter, 1)
        XCTAssertEqual(storageMock.channelID, identifier)
        XCTAssertEqual(storageMock.messages, conversationManagerMock.messagesStub)
    }

    func testGetChannels() throws {

        // Act
        chatDataService.getChannels()

        // Assert
        XCTAssertEqual(conversationManagerMock.callCounter, 1)

        XCTAssertEqual(storageMock.channelsToSave, conversationManagerMock.channelsStub["save"])
        XCTAssertEqual(storageMock.channelsToUpdate, conversationManagerMock.channelsStub["update"])
        XCTAssertEqual(storageMock.channelsToDelete, conversationManagerMock.channelsStub["delete"])
        XCTAssertEqual(storageMock.callCounter, 3)
    }
}
