//
//  HomepageViewController.swift
//  ABC
//
//  Created by Destriana Orchidea on 03/08/24.
//

import Foundation
import UIKit

final class HomepageViewController : UIViewController {
    var viewModel: HomepageViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather Widget"
        
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel.openImagePicker()
        }
    }
}

