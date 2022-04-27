//
//  CategoryVerticalPickerAddCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 27.04.2022.
//

import Foundation
import AUIKit

extension CategoryVerticalPickerController {
class AddCellController: AUIClosuresTableViewCellController {
    
    // MARK: - Data
    
    var title: String {
        didSet { showTitle(title) }
    }
    
    // MARK: - Initilizer
    
    init(title: String) {
        self.title = title
    }
    
    // MARK: - Cell
    
    private typealias CellType = CategoryVerticalPickerView.AddCell
    
    private var addCell: CellType {
        return tableViewCell as! CellType
    }
    
    // MARK: - Create cell
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = super.cellForRowAtIndexPath(indexPath)
        cell.selectionStyle = .none
        showTitle(title)
        return cell
    }
    
    // MARK: - Content
    
    private func showTitle(_ title: String) {
        addCell.titleLabel.text = title
    }
}
}
