//
//  HomepageViewModel.swift
//  ABC
//
//  Created by Destriana Orchidea on 03/08/24.
//

import Foundation
import UIKit

protocol HomepageNavigationDelegate: AnyObject {
    func openImagePicker(imagePickerDelegate: ImagePickerServiceDelegate)
}
class HomepageViewModel {
    private(set) weak var navigationDelegate: HomepageNavigationDelegate!
    
    init(navigationDelegate: HomepageNavigationDelegate) {
        self.navigationDelegate = navigationDelegate
    }
    
    func openImagePicker() {
        navigationDelegate.openImagePicker(imagePickerDelegate: self)
    }
}

extension HomepageViewModel: ImagePickerServiceDelegate {
    func imagePicker(_ imagePicker: ImagePickerService, didSelect image: UIImage) {
        print("KODOK", image.size)
    }

    func cancelButtonDidClick(on imagePicker: ImagePickerService) {
        print("KODOK", "finish")
    }
}

