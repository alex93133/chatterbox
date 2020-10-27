import Foundation
import Firebase

class FirebaseManager {
    
    // MARK: - Properties
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    // MARK: - Functions
    func getChannels(handler: @escaping (FetchResult<[Channel], Error>) -> Void) {
        reference.addSnapshotListener { snapshot, error in
            
            if let error = error {
                handler(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            let channels = snapshot.documents.compactMap { document -> Channel? in
                let channel = Channel(data: document.data(), documentID: document.documentID)
                return channel
            }
            
            CoreDataManager.shared.saveChannelsToDB(channels: channels)
            handler(.success(channels))
        }
    }
    
    func getMessages(identifier: String, handler: @escaping (FetchResult<[Message], Error>) -> Void) {
        let messagesReference = reference.document(identifier).collection("messages")
        
        messagesReference.addSnapshotListener { snapshot, error in
            
            if let error = error {
                handler(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            let messages = snapshot.documents.compactMap { document -> Message? in
                let message = Message(data: document.data(), documentID: document.documentID)
                return message
            }
            
            CoreDataManager.shared.saveMessagesToDB(channelID: identifier, messages: messages)
            handler(.success(messages))
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
}
