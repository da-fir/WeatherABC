//
//  HomepageViewModel.swift
//  ABC
//
//  Created by Destriana Orchidea on 03/08/24.
//

import Foundation
import CoreLocation
import UIKit

protocol HomepageNavigationDelegate: AnyObject {
    func openImagePicker(imagePickerDelegate: ImagePickerServiceDelegate)
}

class HomepageViewModel: HomepageViewModelProtocol {
    private(set) weak var navigationDelegate: HomepageNavigationDelegate!
    private var locationService: LocationServiceProtocol
    
    init(navigationDelegate: HomepageNavigationDelegate, locationSerice: LocationServiceProtocol) {
        self.navigationDelegate = navigationDelegate
        self.locationService = locationSerice
        self.locationService.delegate = self
    }
    
    func viewDidLoad() {
        locationService.requestPermissionIfNeeded()
        locationService.requestUserLocation()
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

extension HomepageViewModel: LocationServiceDelegate {
    func userLocationDidUpdate(location: (String?, String?, Error?)) {
        print("KODOK", location.0, location.1)
    }
    
    func locationServiceDidUpdate(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            print("When user select option Dont't Allow")
        case .authorizedAlways, .authorizedWhenInUse:
            locationService.requestUserLocation()
            print("When user select option Allow While Using App or Allow Once")
        default:
            print("default")
        }
    }
}

