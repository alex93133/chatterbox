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
                Logger.shared.printLogs(text: "Unable to get data from Firebase. Error: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else { return }

            var channelsToSave = [Channel]()
            var channelsToUpdate = [Channel]()
            var channelsToDelete = [Channel]()

            snapshot.documentChanges.forEach { difference in
                guard let channel = Channel(data: difference.document.data(), documentID: difference.document.documentID) else { return }
                switch difference.type {
                case .added:
                    channelsToSave.append(channel)
                case .modified:
                    channelsToUpdate.append(channel)
                case .removed:
                    channelsToDelete.append(channel)
                }
            }
            CoreDataManager.shared.saveChannelsToDB(channelsToSave)
            CoreDataManager.shared.updateChannelsInDB(channelsToUpdate)
            CoreDataManager.shared.deleteChannelsFromDB(channelsToDelete)
        }
    }

    func getMessages(identifier: String) {
        let messagesReference = reference.document(identifier).collection("messages")
        messagesReference.addSnapshotListener { snapshot, error in

            if let error = error {
                Logger.shared.printLogs(text: "Unable to get data from Firebase. Error: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else { return }

            var messagesToSave = [Message]()

            snapshot.documentChanges.forEach { difference in
                guard let message = Message(data: difference.document.data(), documentID: difference.document.documentID) else { return }
                if difference.type == .added {
                    messagesToSave.append(message)
                }
            }

            CoreDataManager.shared.saveMessagesToDB(channelID: identifier, messages: messagesToSave)
        }
    }

    func sendMessage(content: String, identifier: String) {
        let messagesReference = reference.document(identifier).collection("messages")
        let user = UserManager.shared.userModel
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
                Logger.shared.printLogs(text: "Unable to delete channel from Firebase. Error: \(error.localizedDescription)")
                return
            }
        }
    }
}
