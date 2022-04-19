//
//  CategoryColorHorizontalPickerColorCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 19.04.2022.
//

import AUIKit
import UIKit

extension CategoryColorHorizontalPickerController {
final class ColorCellController: AUIClosuresCollectionViewCellController {
    
    // MARK: Data
        
    let color: CategoryColor
    let uiColor: UIColor
    
    // MARK: Initializer
        
    init(color: CategoryColor, uiColor: UIColor, isSelected: Bool) {
        self.color = color
        self.uiColor = uiColor
        self.isSelected = isSelected
        super.init()
    }
    
    // MARK:
    
    private typealias ColorCell = ColorHorizontalPickerView.ColorCell
    private var colorCell: ColorCell? {
        return collectionViewCell as? ColorCell
    }
    
    // MARK: Events

    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = super.cellForItemAtIndexPath(indexPath) as! ColorCell
        collectionViewCell.colorView.backgroundColor = uiColor
        collectionViewCell.setIsSelected(isSelected, animated: false)
        self.collectionViewCell = collectionViewCell
        return collectionViewCell
    }
    
    // MARK: Selection
    
    private var isSelected: Bool
    func setSelected(_ isSelected: Bool, animated: Bool) {
        self.isSelected = isSelected
        colorCell?.setIsSelected(isSelected, animated: animated)
    }
}
}
