import Foundation
import Firebase

protocol NetworkManagerProtocol {
    func getChannels(handler: @escaping (Dictionary<String, [Channel]>) -> Void)
    func getMessages(identifier: String, handler: @escaping ([Message]) -> Void)
    func sendMessage(sender: User, content: String, identifier: String)
    func createChannel(name: String)
    func deleteChannel(identifier: String)
}

class FirebaseManager: NetworkManagerProtocol {

    // MARK: - Properties
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")

    // MARK: - Functions
    func getChannels(handler: @escaping (Dictionary<String, [Channel]>) -> Void) {
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
            
            let channelsDictionarry: Dictionary<String, [Channel]> = ["save": channelsToSave,
                                                                      "update": channelsToUpdate,
                                                                      "delete": channelsToDelete]
            handler(channelsDictionarry)

        }
    }
    
    private func updateDictionary(with channel: Channel, key: String) {
        
    }

    func getMessages(identifier: String, handler: @escaping ([Message]) -> Void) {
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

            handler(messagesToSave)
        }
    }

    func sendMessage(sender: User, content: String, identifier: String) {
        let messagesReference = reference.document(identifier).collection("messages")
        let data: [String: Any] = [ "content": content,
                                    "created": Timestamp(date: Date()),
                                    "senderId": sender.uuID,
                                    "senderName": sender.name ]

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
