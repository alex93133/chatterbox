import UIKit
import CoreData

// MARK: - TableView
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageDB = fetchedResultsController.object(at: indexPath)
        let cellModel = MessageCellModel(message: messageDB, userDataService: model.userDataService)

        if cellModel.isIncoming {
            if let incomingCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.incomingMessageCell,
                                                                for: indexPath) as? IncomingMessageTableViewCell {
                incomingCell.themesService = model.themesService
                incomingCell.configure(with: cellModel)
                return incomingCell
            }
        } else {
            if let outgoingCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.outgoingMessageCell,
                                                                for: indexPath) as? OutgoingMessageTableViewCell {
                outgoingCell.themesService = model.themesService
                outgoingCell.configure(with: cellModel)
                return outgoingCell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - FRC
extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationView.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                conversationView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

        case .update:
            if let indexPath = indexPath {
                let messageDB = fetchedResultsController.object(at: indexPath)
                let cellModel = MessageCellModel(message: messageDB, userDataService: model.userDataService)
                if cellModel.isIncoming {
                    guard let cell = conversationView.tableView.cellForRow(at: indexPath) as? IncomingMessageTableViewCell else { break }
                    cell.configure(with: cellModel)
                } else {
                    guard let cell = conversationView.tableView.cellForRow(at: indexPath) as? OutgoingMessageTableViewCell else { break }
                    cell.configure(with: cellModel)
                }
            }

        case .move:
            if let indexPath = indexPath {
                conversationView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                conversationView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

        case .delete:
            if let indexPath = indexPath {
                conversationView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }

        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationView.tableView.endUpdates()
        scrollTableViewToLast()
    }
}

// MARK: - TextView
extension ConversationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewHeight()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = model.themesService.textColor
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setTextViewPlaceHolder()
        }
    }
}
