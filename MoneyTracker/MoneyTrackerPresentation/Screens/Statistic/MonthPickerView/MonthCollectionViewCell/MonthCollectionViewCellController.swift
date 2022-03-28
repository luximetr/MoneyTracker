//
//  MonthCollectionViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 25.03.2022.
//

import UIKit
import AUIKit

extension StatisticScreenViewController {
final class MonthCollectionViewCellController: AUIClosuresCollectionViewCellController {
    
    // MARK: Data
        
    let month: Date
    private(set) var isSelected: Bool
    
    func setSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
        monthCollectionViewCell?.setSelected(isSelected)
    }
    
    // MARK: Initializer
        
    init(month: Date, isSelected: Bool) {
        self.month = month
        self.isSelected = isSelected
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
    
    // MARK: Content
    
    private func setContent() {
        let month = Self.month(month)
        monthCollectionViewCell?.monthLabel.text = month
        monthCollectionViewCell?.setSelected(isSelected)
    }
    
    private static let monthDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(language: .english, script: nil, region: nil)
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter
    }()
    
    static func month(_ month: Date) -> String {
        let month = Self.monthDateFormatter.string(from: month)
        return month
    }

}
}
