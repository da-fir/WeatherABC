//
//  HomepageCoordinator.swift
//  ABC
//
//  Created by Destriana Orchidea on 03/08/24.
//

import ABCCore
import Foundation
import UIKit

class HomepageCoordinator : Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        if let homepageViewController: HomepageViewController = storyboard.instantiateViewController(withIdentifier: "HomepageViewController") as? HomepageViewController {
            let homepageViewModel: HomepageViewModel = HomepageViewModel(navigationDelegate: self, locationSerice: LocationService(), resourceService: ResourcesService())
            homepageViewController.viewModel = homepageViewModel
            navigationController.pushViewController(homepageViewController, animated: true)
        }
    }
}

extension HomepageCoordinator : HomepageNavigationDelegate {
    func openImagePicker(imagePickerDelegate: ImagePickerServiceDelegate) {
        let imagePickerCoordinator: ImagePickerCoordinator = ImagePickerCoordinator(navigationController: navigationController)
        imagePickerCoordinator.parentCoordinator = self
        children.append(imagePickerCoordinator)
        
        imagePickerCoordinator.startWithDelegate(imagePickerDelegate)
    }
}
