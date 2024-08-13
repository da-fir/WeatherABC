//
//  HomepageCollectionView.swift
//  ABC
//
//  Created by Destriana Orchidea on 13/08/24.
//

import UIKit

public final class HomepageCollectionView: UICollectionView {
    override public var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        
        let height: CGFloat = contentSize.height + contentInset.top + contentInset.bottom
        
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    override public var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
}

