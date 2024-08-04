//
//  LocationService.swift
//  ABC
//
//  Created by Destriana Orchidea on 05/08/24.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func locationServiceDidUpdate(_ status: CLAuthorizationStatus)
    func userLocationDidUpdate(location: CLLocation)
}
protocol LocationServiceProtocol: AnyObject {
    var delegate: LocationServiceDelegate? { get set }
    func requestPermissionIfNeeded()
    func requestUserLocation()
}

final class LocationService: NSObject, LocationServiceProtocol {
    weak var delegate: LocationServiceDelegate?
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
    }
    
    func requestPermissionIfNeeded() {
        let currentStatus = CLLocationManager.authorizationStatus()
        
        // Only ask authorization if it was never asked before
        guard currentStatus == .notDetermined else { return }
        
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func requestUserLocation() {
        locationManager.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = manager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if authorizationStatus == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
        delegate?.locationServiceDidUpdate(authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.userLocationDidUpdate(location: location)
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        
        if let clErr = error as? CLError {
            switch clErr.code {
            case .locationUnknown, .denied, .network:
                print("Location request failed with error: \(clErr.localizedDescription)")
            case .headingFailure:
                print("Heading request failed with error: \(clErr.localizedDescription)")
            case .rangingUnavailable, .rangingFailure:
                print("Ranging request failed with error: \(clErr.localizedDescription)")
            case .regionMonitoringDenied, .regionMonitoringFailure, .regionMonitoringSetupDelayed, .regionMonitoringResponseDelayed:
                print("Region monitoring request failed with error: \(clErr.localizedDescription)")
            default:
                print("Unknown location manager error: \(clErr.localizedDescription)")
            }
        } else {
            print("Unknown error occurred while handling location manager error: \(error.localizedDescription)")
        }
    }
}
