//
//  ABCHomeCell.swift
//  ABC
//
//  Created by Destriana Orchidea on 13/08/24.
//
import UIKit

final class ABCHomeCell: UICollectionViewCell {
    static let identifier: String = "ABCHomeCell"
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    func setup(uiimage: UIImage) {
        wrapperView.layer.cornerRadius = 10.0
        imageView.image = uiimage
    }
}

