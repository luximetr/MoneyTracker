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
    var backgroundColor: UIColor {
        didSet {
            guard let iconCell = iconCell else { return }
            updateCell(cell: iconCell, backgroundColor: backgroundColor)
        }
    }
    
    // MARK: - Life cycle
    
    init(iconName: String, backgroundColor: UIColor) {
        self.iconName = iconName
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Create cell
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = super.cellForItemAtIndexPath(indexPath) as? ScreenView.IconCell else { return UICollectionViewCell() }
        cell.iconView.iconImageView.image = UIImage(systemName: iconName)
        updateCell(cell: cell, backgroundColor: backgroundColor)
        return cell
    }
    
    // MARK: - Get cell
    
    private var iconCell: ScreenView.IconCell? {
        return collectionViewCell as? ScreenView.IconCell
    }
    
    private func updateCell(cell: ScreenView.IconCell, backgroundColor: UIColor) {
        cell.iconView.backgroundColor = backgroundColor
    }
    
}
}
