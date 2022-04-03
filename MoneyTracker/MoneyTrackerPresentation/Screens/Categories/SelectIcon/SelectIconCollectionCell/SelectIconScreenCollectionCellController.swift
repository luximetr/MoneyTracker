//
//  SelectIconScreenCollectionCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.04.2022.
//

import AUIKit

extension SelectIconScreenViewController {
final class IconCellController: AUIClosuresCollectionViewCellController {
    
    // MARK: - Data
    
    let iconName: String
    let backgroundColor: UIColor
    
    // MARK: - Life cycle
    
    init(iconName: String, backgroundColor: UIColor) {
        self.iconName = iconName
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Create cell
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = super.cellForItemAtIndexPath(indexPath) as? ScreenView.IconCell else { return UICollectionViewCell() }
        cell.iconView.iconImageView.image = UIImage(systemName: iconName)
        cell.iconView.backgroundColor = backgroundColor
        return cell
    }
    
}
}
