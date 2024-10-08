//
//  ImagePickerService.swift
//  ABC
//
//  Created by Destriana Orchidea on 04/08/24.
//

import UIKit

// MARK: - ImagePickerDelegate Protocol
protocol ImagePickerServiceDelegate: AnyObject {
    func imagePicker(_ imagePicker: ImagePickerService, didSelect image: UIImage)
    func cancelButtonDidClick(on imagePicker: ImagePickerService)
}

// MARK: - ImagePicker Class
final class ImagePickerService: NSObject {
    
    // MARK: - Properties
    private weak var controller: UIImagePickerController?
    weak var delegate: ImagePickerServiceDelegate?
    
    // MARK: - Public Methods
    
    // Dismiss the image picker
    func dismiss() {
        controller?.dismiss(animated: true, completion: nil)
    }
    
    // Present the image picker with source type and editing option
    func present(from viewController: UIViewController, sourceType: UIImagePickerController.SourceType, allowsEditing: Bool = false) {
        
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = allowsEditing
        self.controller = imagePickerController
        
        DispatchQueue.main.async {
            viewController.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // Display an alert to choose between camera and photo library
    func showImagePicker(from viewController: UIViewController, allowsEditing: Bool) {
        
        let optionMenu = UIAlertController(title: "Select an image source", message: nil, preferredStyle: .alert)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
                self.present(from: viewController, sourceType: .camera, allowsEditing: allowsEditing)
            }
            optionMenu.addAction(takePhotoAction)
        }
        
        let selectFromLibraryAction = UIAlertAction(title: "Select from Library", style: .default) { [unowned self] _ in
            self.present(from: viewController, sourceType: .photoLibrary, allowsEditing: allowsEditing)
        }
        optionMenu.addAction(selectFromLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        viewController.present(optionMenu, animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate
extension ImagePickerService: UINavigationControllerDelegate { }

// MARK: - UIImagePickerControllerDelegate
extension ImagePickerService: UIImagePickerControllerDelegate {
    
    // Called when an image is selected or captured
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: originalImage)
        } else {
            print("Image source not recognized")
        }
    }

    // Called when the user cancels the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.cancelButtonDidClick(on: self)
    }
}
