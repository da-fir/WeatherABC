//
//  ImagePickerCoordinator.swift
//  ABC
//
//  Created by Destriana Orchidea on 04/08/24.
//

import Foundation
import UIKit

final class ImagePickerCoordinator : Coordinator {
    weak var delegate: ImagePickerServiceDelegate?
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    private lazy var imagePickerService: ImagePickerService = ImagePickerService()
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func startWithDelegate(_ delegate: ImagePickerServiceDelegate) {
        self.delegate = delegate
        imagePickerService.delegate = self
        start()
    }
    func start() {
        print("ImagePickerCoordinator Start")
        imagePickerService.showImagePicker(from: navigationController.topViewController!, allowsEditing: false)
    }
    
    deinit {
        print("ImagePickerCoordinator deinit")
    }
}

extension ImagePickerCoordinator: ImagePickerServiceDelegate {
    func imagePicker(_ imagePicker: ImagePickerService, didSelect image: UIImage) {
        navigationController.popToRootViewController(animated: true)
        delegate?.imagePicker(imagePicker, didSelect: image)
        parentCoordinator?.childDidFinish(self)
    }
    
    func cancelButtonDidClick(on imagePicker: ImagePickerService) {
        navigationController.popToRootViewController(animated: true)
        delegate?.cancelButtonDidClick(on: imagePicker)
        parentCoordinator?.childDidFinish(self)
    }
}
