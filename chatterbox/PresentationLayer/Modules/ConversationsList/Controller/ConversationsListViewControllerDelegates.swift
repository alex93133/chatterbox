import UIKit
import CoreData

// MARK: - TableView
extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Channels", comment: "")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.conversationCell,
                                                    for: indexPath) as? ConversationTableViewCell {
            let channelDB = fetchedResultsController.object(at: indexPath)
            let cellModel = ConversationCellModel(channel: channelDB)
            cell.themesService = model.themesService
            cell.configure(with: cellModel)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channelDB = fetchedResultsController.object(at: indexPath)
        let conversationViewController = presentationAssembly.conversationViewController(with: channelDB)
        navigationController?.pushViewController(conversationViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = model.themesService.textColor
        header.contentView.backgroundColor = model.themesService.mainBGColor.withAlphaComponent(0.8)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete", comment: "")) { [weak self] (_, indexPath) in
            guard let self = self else { return }
            let channelDB = self.fetchedResultsController.object(at: indexPath)
            if let identifier = channelDB.identifier {
                self.model.firebaseService.deleteChannel(identifier: identifier)
            }
        }
        return [deleteAction]
    }
}

// MARK: - FRC
extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationsListView.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                conversationsListView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

        case .update:
            if let indexPath = indexPath,
               let cell = conversationsListView.tableView.cellForRow(at: indexPath) as? ConversationTableViewCell {
                let channelDB = fetchedResultsController.object(at: indexPath)
                let cellModel = ConversationCellModel(channel: channelDB)
                cell.configure(with: cellModel)
            }

        case .move:
            if let indexPath = indexPath {
                conversationsListView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                conversationsListView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

        case .delete:
            if let indexPath = indexPath {
                conversationsListView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }

        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationsListView.tableView.endUpdates()
    }
}

// MARK: - ThemesPicker
extension ConversationsListViewController: ThemesPickerDelegate {
    func updateColors() {
        conversationsListView.tableView.backgroundColor = model.themesService.mainBGColor
        conversationsListView.backgroundColor = model.themesService.mainBGColor
        navigationItem.leftBarButtonItem?.tintColor = model.themesService.barItemColor
        conversationsListView.tableView.reloadData()
        guard let cells = conversationsListView.tableView.visibleCells as? [ConversationTableViewCell] else { return }
        cells.forEach { $0.nameLabel.textColor = model.themesService.textColor }
    }
}
