//
//  TemplatesScreenTemplateTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 15.02.2022.
//

import UIKit
import AUIKit

extension TemplatesScreenViewController {
    
    final class TemplateTableViewCellController: AUIClosuresTableViewCellController {
        
        // MARK: - Id
        
        let templateId: String
        
        // MARK: - Life cycle
        
        init(templateId: String,
             name: String,
             amount: Decimal,
             balanceAccountName: String,
             categoryName: String,
             comment: String?
        ) {
            self.templateId = templateId
            self.name = name
            self.amount = amount
            self.balanceAccountName = balanceAccountName
            self.categoryName = categoryName
            self.comment = comment
        }
        
        // MARK: - Cell
        
        private typealias CellType = TemplatesScreenView.TemplateTableViewCell
        private var templateCell: CellType {
            return tableViewCell as! CellType
        }
        
        // MARK: - Cell - Create
        
        override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
            guard let cell = super.cellForRowAtIndexPath(indexPath) as? CellType else { return UITableViewCell() }
            updateName(to: name, in: cell)
            updateAmount(to: amount, in: cell)
            updateBalanceAccountName(to: balanceAccountName, in: cell)
            updateCategoryName(to: categoryName, in: cell)
            updateComment(to: comment, in: cell)
            return cell
        }
        
        // MARK: - Name
        
        var name: String {
            didSet { updateName(to: name, in: templateCell) }
        }
        
        private func updateName(to name: String, in cell: CellType) {
            cell.nameLabel.text = name
        }
        
        // MARK: - Amount
        
        var amount: Decimal {
            didSet { updateAmount(to: amount, in: templateCell) }
        }
        
        private func updateAmount(to amount: Decimal, in cell: CellType) {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.currencySymbol = "SGD"
            let amountString = formatter.string(from: NSDecimalNumber(decimal: amount))
            cell.amountLabel.text = amountString
        }
        
        // MARK: - Balance account name
        
        var balanceAccountName: String {
            didSet { updateBalanceAccountName(to: balanceAccountName, in: templateCell) }
        }
        
        private func updateBalanceAccountName(to balanceAccountName: String, in cell: CellType) {
            cell.balanceAccountLabel.text = balanceAccountName
        }
        
        // MARK: - Category name
        
        var categoryName: String {
            didSet { updateCategoryName(to: categoryName, in: templateCell) }
        }
        
        private func updateCategoryName(to categoryName: String, in cell: CellType) {
            cell.categoryLabel.text = categoryName
        }
        
        // MARK: - Comment
        
        var comment: String?
        
        private func updateComment(to comment: String?, in cell: CellType) {
            cell.commentLabel.text = comment
        }
    }
}
