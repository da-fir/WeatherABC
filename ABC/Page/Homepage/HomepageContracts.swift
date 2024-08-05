//
//  HomepageContracts.swift
//  ABC
//
//  Created by Destriana Orchidea on 06/08/24.
//

import Foundation
import UIKit

struct WidgetCellViewAttributes {
    let backgroundImage: UIImage
    let weatherIcon: UIImage
    let title: String
}

protocol HomepageViewModelProtocol {
    func viewDidLoad()
    func openImagePicker()
}
