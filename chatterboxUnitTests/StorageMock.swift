import Foundation
@testable import chatterbox

class StorageMock: StorageProtocol {
    var callCounter = 0

    var channelID: String!
    var messages: [Message]!
    var channelsToSave: [Channel]!
    var channelsToUpdate: [Channel]!
    var channelsToDelete: [Channel]!

    func saveMessagesToDB(channelID: String, messages: [Message]) {
        callCounter += 1
        self.channelID = channelID
        self.messages = messages
    }

    func saveChannelsToDB(_ channels: [Channel]) {
        callCounter += 1
        channelsToSave = channels
    }

    func deleteChannelsFromDB(_ channels: [Channel]) {
        callCounter += 1
        channelsToDelete = channels
    }

    func updateChannelsInDB(_ channels: [Channel]) {
        callCounter += 1
        channelsToUpdate = channels
    }
}
