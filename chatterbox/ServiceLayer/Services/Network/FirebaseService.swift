import Foundation
import Firebase

protocol FirebaseServiceProtocol {
    func getChannels()
    func getMessages(identifier: String)
    func sendMessage(content: String, identifier: String)
    func createChannel(name: String)
    func deleteChannel(identifier: String)
}

class FirebaseService: FirebaseServiceProtocol {
    
    // MARK: - Properties
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    // MARK: - Dependencies
    var coreDataService: CoreDataServiceProtocol
    var userDataService: UserDataServiceProtocol
    
    init(coreDataService: CoreDataServiceProtocol, userDataService: UserDataServiceProtocol) {
        self.coreDataService = coreDataService
        self.userDataService = userDataService
    }
    
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
            self.coreDataService.saveChannelsToDB(channelsToSave)
            self.coreDataService.updateChannelsInDB(channelsToUpdate)
            self.coreDataService.deleteChannelsFromDB(channelsToDelete)
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
            
            self.coreDataService.saveMessagesToDB(channelID: identifier, messages: messagesToSave)
        }
    }
    
    func sendMessage(content: String, identifier: String) {
        let messagesReference = reference.document(identifier).collection("messages")
        let user = userDataService.userModel
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
