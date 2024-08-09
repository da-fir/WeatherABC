//
//  ResourcesService.swift
//  ABCCore
//
//  Created by Destriana Orchidea on 09/08/24.
//

import Foundation
import UIKit

private let coreIdentifier: String = "com.yourcompany.ABCCore"
private let groupID: String = "group.com.yourcompany.ABC"
private let kWidgetImage: String = "widgetImage"

public protocol ResourcesServiceProtocol: AnyObject {
    func setWidgetBackgroundImage(image: UIImage)
    func getWidgetBackgroundImage() -> UIImage?
    func loadLocalImage(image named: String) -> UIImage
}

public final class ResourcesService: NSObject, ResourcesServiceProtocol {
    public func setWidgetBackgroundImage(image: UIImage) {
        guard let encoded: Data = try? PropertyListEncoder().encode(image.jpegData(compressionQuality: 1.0))
        else {
            return
        }
        UserDefaults(suiteName: groupID)?.set(encoded, forKey: kWidgetImage)
    }
    
    public func getWidgetBackgroundImage() -> UIImage? {
        guard let data = UserDefaults(suiteName: groupID)?.data(forKey: kWidgetImage),
              let decoded: Data = try? PropertyListDecoder().decode(Data.self, from: data)
        else { return nil }
        
        return UIImage(data: decoded)
    }
    
    public func loadLocalImage(image named: String) -> UIImage {
        return UIImage(named: named, in: Bundle(identifier: coreIdentifier), with: nil) ?? UIImage()
    }
}
