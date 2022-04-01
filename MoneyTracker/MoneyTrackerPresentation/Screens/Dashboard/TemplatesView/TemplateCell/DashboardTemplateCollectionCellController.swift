//
//  DashboardTemplateCollectionCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 23.03.2022.
//

import UIKit
import AUIKit

extension DashboardScreenViewController {
final class TemplateCollectionCellController: AUIClosuresCollectionViewCellController {
    
    // MARK: - Id
    
    let templateId: String
    
    // MARK: - Life cycle
    
    init(title: String, templateId: String) {
        self.title = title
        self.templateId = templateId
    }
    
    // MARK: - Cell
    
    typealias CellType = TemplateCollectionCell
    
    private var templateCell: CellType {
        return collectionViewCell as! CellType
    }
    
    // MARK: - Create cell
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = super.cellForItemAtIndexPath(indexPath) as? TemplateCollectionCell else { return UICollectionViewCell() }
        updateTitle(title, in: cell)
        return cell
    }
    
    // MARK: - Title
    
    var title: String {
        didSet { updateTitle(title, in: templateCell) }
    }
    
    private func updateTitle(_ title: String, in cell: CellType) {
        cell.titleLabel.text = title
    }
}
}
