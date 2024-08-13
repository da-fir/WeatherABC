//
//  LocationService.swift
//  ABC
//
//  Created by Destriana Orchidea on 05/08/24.
//

import Foundation
import CoreLocation

public protocol LocationServiceDelegate: AnyObject {
    func locationServiceDidUpdate(_ status: CLAuthorizationStatus)
    func userLocationDidUpdate(location: (CurrentLocationResult))
}
public protocol LocationServiceProtocol: AnyObject {
    var delegate: LocationServiceDelegate? { get set }
    var locationManager: CLLocationManager { get }
    func requestPermissionIfNeeded()
    func requestUserLocation()
    func requestUserLocation(handler: ((CurrentLocationResult) -> Void)?)
}

public final class LocationService: NSObject, LocationServiceProtocol {
    public weak var delegate: LocationServiceDelegate?
    public let locationManager: CLLocationManager
    private var handler: ((CurrentLocationResult) -> Void)?
    
    public override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
    }
    
    public func requestPermissionIfNeeded() {
        let currentStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            currentStatus = CLLocationManager().authorizationStatus
        } else {
            currentStatus = CLLocationManager.authorizationStatus()
        }
        
        // Only ask authorization if it was never asked before
        guard currentStatus == .notDetermined else { return }
        
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    public func requestUserLocation() {
        locationManager.requestLocation()
    }
    
    public func requestUserLocation(handler: ((CurrentLocationResult) -> Void)?) {
        self.handler = handler
        print("KODOK>>> YEEY")
        requestUserLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
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
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("KODOK>>> YEEY1")
        guard let location = locations.last else { return }
        print("KODOK>>> YEEY2")
        location.fetchCityAndCountry { city, country, error in
            self.handler?(CurrentLocationResult(location: location, city: city, country: country, error: error))// send to handler if any
            self.delegate?.userLocationDidUpdate(location: (CurrentLocationResult(location: location, city: city, country: country, error: error)))
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
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

private extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
