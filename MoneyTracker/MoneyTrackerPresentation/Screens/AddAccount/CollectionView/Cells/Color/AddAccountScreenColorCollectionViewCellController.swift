//
//  AddAccountScreenColorCollectionViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 11.02.2022.
//

import UIKit
import AUIKit

extension AddAccountScreenViewController {
final class ColorCollectionViewCellController: AUIClosuresCollectionViewCellController {
        
    // MARK: Data
        
    let backgroundColor: UIColor
    
    // MARK: Initializer
        
    init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        super.init()
    }
    
    // MARK:
    
    private var colorCollectionViewCell: AddAccountScreenView.ColorCollectionViewCell? {
        return collectionViewCell as? AddAccountScreenView.ColorCollectionViewCell
    }
    
    // MARK: Events

    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = super.cellForItemAtIndexPath(indexPath) as! AddAccountScreenView.ColorCollectionViewCell
        collectionViewCell.colorView.backgroundColor = backgroundColor
        collectionViewCell.setIsSelected(isSelected, animated: false)
        self.collectionViewCell = collectionViewCell
        return collectionViewCell
    }
    
    override func didEndDisplayingCell() {
        super.didEndDisplayingCell()
        
    }
    
    // MARK: Selection
    
    private var isSelected: Bool = false
    func setSelected(_ isSelected: Bool, animated: Bool) {
        self.isSelected = isSelected
        colorCollectionViewCell?.setIsSelected(isSelected, animated: animated)
    }
    
}
}
