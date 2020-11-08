import Foundation
import Firebase

class FirebaseManager {

    static let shared = FirebaseManager()
    private init() {}

    // MARK: - Properties
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")

    // MARK: - Functions
    func getChannels() {
        reference.addSnapshotListener { snapshot, error in

            if let error = error {
                LoggerService.shared.printLogs(text: "Unable to get data from Firebase. Error: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else { return }

            var channelsToSave = [ChannelModel]()
            var channelsToUpdate = [ChannelModel]()
            var channelsToDelete = [ChannelModel]()

            snapshot.documentChanges.forEach { difference in
                guard let channel = ChannelModel(data: difference.document.data(), documentID: difference.document.documentID) else { return }
                switch difference.type {
                case .added:
                    channelsToSave.append(channel)
                case .modified:
                    channelsToUpdate.append(channel)
                case .removed:
                    channelsToDelete.append(channel)
                }
            }
            CoreDataService.shared.saveChannelsToDB(channelsToSave)
            CoreDataService.shared.updateChannelsInDB(channelsToUpdate)
            CoreDataService.shared.deleteChannelsFromDB(channelsToDelete)
        }
    }

    func getMessages(identifier: String) {
        let messagesReference = reference.document(identifier).collection("messages")
        messagesReference.addSnapshotListener { snapshot, error in

            if let error = error {
                LoggerService.shared.printLogs(text: "Unable to get data from Firebase. Error: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else { return }

            var messagesToSave = [MessageModel]()

            snapshot.documentChanges.forEach { difference in
                guard let message = MessageModel(data: difference.document.data(), documentID: difference.document.documentID) else { return }
                if difference.type == .added {
                    messagesToSave.append(message)
                }
            }

            CoreDataService.shared.saveMessagesToDB(channelID: identifier, messages: messagesToSave)
        }
    }

    func sendMessage(content: String, identifier: String) {
        let messagesReference = reference.document(identifier).collection("messages")
        let user = UserDataService.shared.userModel
        let data: [String: Any] = [ "content": content,
                                    "created": Timestamp(date: Date()),
                                    "senderId": user.uuID,
                                    "senderName": user.name ]

        messagesReference.addDocument(data: data)
    }

    func createChannel(name: String) {
        let data = [ "name": name ]
        reference.addDocument(data: data)
    }

    func deleteChannel(identifier: String) {
        let channelReference = reference.document(identifier)

        channelReference.delete { error in
            if let error = error {
                LoggerService.shared.printLogs(text: "Unable to delete channel from Firebase. Error: \(error.localizedDescription)")
                return
            }
        }
    }
}
