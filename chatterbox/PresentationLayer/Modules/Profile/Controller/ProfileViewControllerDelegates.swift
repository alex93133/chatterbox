import UIKit

// MARK: - Picker
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage,
           let resizedImage = image.resizeImage(image: image, newWidth: 300) {
            profileView.photoImageView.image = resizedImage
            updatedModel.photo = resizedImage
            isAbleToSave = true
        }
        picker.dismiss(animated: true)
    }
}

// MARK: - TextView
extension ProfileViewController: UITextViewDelegate {
    private func textViewValidate() {
        guard let name = profileView.nameTextView.text,
              let description = profileView.descriptionTextView.text,
              !profileView.nameTextView.text.isEmpty,
              !profileView.descriptionTextView.text.isEmpty
        else { return }

        let state = (name != profileModel.name || description != profileModel.description) ? true : false
        updatedModel.name = name
        updatedModel.description = description
        isAbleToSave = state
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textViewValidate()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}

// MARK: - ImagesList
extension ProfileViewController: ImagesListViewControllerDelegate {
    func handleSelection(_ image: UIImage) {
        profileView.photoImageView.image = image
        updatedModel.photo = image
        isAbleToSave = true
    }
}
