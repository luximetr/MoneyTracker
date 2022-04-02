//
//  DashboardTemplateCollectionCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 23.03.2022.
//

import UIKit
import AUIKit

extension DashboardScreenViewController {
final class TemplateCollectionViewCellController: AUIClosuresCollectionViewCellController {
    
    // MARK: - Id
    
    let template: ExpenseTemplate
    
    // MARK: - Life cycle
    
    init(template: ExpenseTemplate) {
        self.template = template
    }
    
    // MARK: - Cell
    
    private var templateCell: TemplateCollectionViewCell {
        return collectionViewCell as! TemplateCollectionViewCell
    }
    
    // MARK: - Create cell
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = super.cellForItemAtIndexPath(indexPath) as? TemplateCollectionViewCell else { return UICollectionViewCell() }
        updateTitle(template.name, in: cell)
        return cell
    }
    
    // MARK: - Title
    
    private func updateTitle(_ title: String, in cell: TemplateCollectionViewCell) {
        cell.titleLabel.text = title
    }
}
}
