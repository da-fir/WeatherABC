//
//  CurrentLocationResult.swift
//  SandboxApp
//
//  Created by Darul Firmansyah on 28/06/24.
//

import CoreLocation
import Foundation

public struct CurrentLocationResult {
    public let location: CLLocation
    public let city: String?
    public let country: String?
    public let error: Error?
    
    public init(location: CLLocation, city: String?, country: String?, error: Error?) {
        self.location = location
        self.city = city
        self.country = country
        self.error = error
    }
}

