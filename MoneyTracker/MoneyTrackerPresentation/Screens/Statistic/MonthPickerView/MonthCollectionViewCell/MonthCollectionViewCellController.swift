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
    
    // MARK: Data
        
    let month: Date
    var isSelected: Bool
    
    // MARK: Initializer
        
    init(month: Date, isSelected: Bool) {
        self.month = month
        self.isSelected = isSelected
        super.init()
    }
    
    // MARK: Collection View Cell
    
    var monthCollectionViewCell: MonthCollectionViewCell? {
        return collectionViewCell as? MonthCollectionViewCell
    }
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.cellForItemAtIndexPath(indexPath) as! MonthCollectionViewCell
        let month = Self.monthDateFormatter.string(from: month)
        cell.monthLabel.text = month
        cell.setSelected(isSelected)
        return cell
    }
    
    // MARK: States
    
    func setSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
        monthCollectionViewCell?.setSelected(isSelected)
    }

}
}
