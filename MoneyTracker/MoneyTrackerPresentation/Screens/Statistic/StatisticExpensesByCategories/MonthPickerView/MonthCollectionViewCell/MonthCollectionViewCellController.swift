//
//  MonthCollectionViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 25.03.2022.
//

import UIKit
import AUIKit

extension StatisticExpensesByCategoriesScreenViewController {
final class MonthCollectionViewCellController: AUIClosuresCollectionViewCellController {
    
    // MARK: Data
        
    private var locale: Locale
    let month: Date
    private(set) var isSelected: Bool
    
    func setSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
        monthCollectionViewCell?.setSelected(isSelected)
    }
    
    // MARK: Initializer
        
    init(locale: Locale, month: Date, isSelected: Bool, monthDateFormatter: DateFormatter) {
        self.locale = locale
        self.month = month
        self.isSelected = isSelected
        self.monthDateFormatter = monthDateFormatter
        super.init()
    }
    
    // MARK: MonthCollectionViewCell
    
    var monthCollectionViewCell: MonthCollectionViewCell? {
        return collectionViewCell as? MonthCollectionViewCell
    }
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.cellForItemAtIndexPath(indexPath)
        setContent()
        return cell
    }
    
    override func willDisplayCell(_ cell: UICollectionViewCell) {
        super.willDisplayCell(cell)
        setContent()
    }
    
    override var shouldSelectCell: Bool {
        let shouldSelectCell = !isSelected
        return shouldSelectCell
    }
    
    // MARK: - Language
    
    func changeLocale(_ locale: Locale) {
        self.locale = locale
        setContent()
    }
    
    // MARK: Content
    
    private func setContent() {
        let month = monthDateFormatter.string(from: month)
        monthCollectionViewCell?.monthLabel.text = month
        monthCollectionViewCell?.setSelected(isSelected)
    }
    
    private let monthDateFormatter: DateFormatter
    
    func formatMonth(_ month: Date) -> String {
        let month = monthDateFormatter.string(from: month)
        return month
    }

}
}
