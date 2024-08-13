//
//  HomepageViewModel.swift
//  ABC
//
//  Created by Destriana Orchidea on 03/08/24.
//

import ABCCore
import Foundation
import CoreLocation
import UIKit

protocol HomepageNavigationDelegate: AnyObject {
    func openImagePicker(imagePickerDelegate: ImagePickerServiceDelegate)
}

class HomepageViewModel: HomepageViewModelProtocol {
    private(set) weak var navigationDelegate: HomepageNavigationDelegate!
    private var locationService: LocationServiceProtocol
    private var resourceService: ResourcesServiceProtocol
    private var networkManager: NetworkManagerProtocol
    
    init(navigationDelegate: HomepageNavigationDelegate, locationSerice: LocationServiceProtocol, resourceService: ResourcesServiceProtocol, networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        self.navigationDelegate = navigationDelegate
        self.resourceService = resourceService
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
        resourceService.setWidgetBackgroundImage(image: image)
    }

    func cancelButtonDidClick(on imagePicker: ImagePickerService) {
        print("KODOK", "finish")
    }
}

extension HomepageViewModel: LocationServiceDelegate {
    func userLocationDidUpdate(location: (CurrentLocationResult)) {
        Task {
            if let response: WeatherResponse = try? await self.networkManager.asyncRequest(endpoint: .weather(location.location))
            {
                print("Fetched \(response.weather?.first?.main?.imageName) favorites.")
            } else {
                print("Failed to fetch favorites.")
            }
        }
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

