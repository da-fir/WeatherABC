//
//  HomepageViewController.swift
//  ABC
//
//  Created by Destriana Orchidea on 03/08/24.
//

import ABCCore
import Foundation
import UIKit

final class HomepageViewController : UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: HomepageCollectionView!
    @IBOutlet weak var changeBgButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: HomepageViewModelProtocol!
    let itemCount = 3
    let resourceService: ResourcesServiceProtocol = ResourcesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather Widget"
        titleLabel.text = "Show Case"
        changeBgButton.setTitle("Change background", for: .normal)
        
        viewModel.viewDidLoad()
        setupCollection()
    }
    
    @IBAction func onChangeBgTapped(_ sender: Any) {
        self.viewModel.openImagePicker()
    }
    
    private func setupCollection() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                                           heightDimension: .absolute(244))
            let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            return section
        }
    }
}

extension HomepageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ABCHomeCell
                = collectionView.dequeueReusableCell(withReuseIdentifier: ABCHomeCell.identifier, for: indexPath) as? ABCHomeCell
        else {
            return UICollectionViewCell(frame: .zero)
        }
        cell.setup(uiimage: resourceService.getWidgetBackgroundImage() ?? UIImage())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // no op
    }
}

