//
//  HomepageViewController.swift
//  ABC
//
//  Created by Destriana Orchidea on 03/08/24.
//

import Foundation
import UIKit

final class HomepageViewController : UIViewController {
    var viewModel : HomepageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather Widget"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel.openImagePicker()
        }
    }
}

