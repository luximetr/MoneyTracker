//
//  DateHorizontalPickerDateCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 02.05.2022.
//

import Foundation
import UIKit
import AUIKit

extension DateHorizontalPickerViewController {
class DateCellController: AUIClosuresCollectionViewCellController {
    
    // MARK: - Data
    
    let date: Date
    private(set) var title: String
    
    // MARK: - Initializer
    
    init(date: Date, title: String) {
        self.date = date
        self.title = title
        super.init()
    }
    
    // MARK: - Cell
    
    private typealias DateCell = DateHorizontalPickerView.DateCell
    
    private var dateCell: DateCell? {
        return collectionViewCell as? DateCell
    }
    
    // MARK: - Cell - Create
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.cellForItemAtIndexPath(indexPath)
        setCellTitle()
        return cell
    }
    
    func setTitle(_ title: String) {
        self.title = title
        setCellTitle()
    }
    
    private func setCellTitle() {
        dateCell?.titleLabel.text = title
    }
}
}
