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
        
    private static let dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(language: .english, script: nil, region: nil)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter
    }()
    
    static func month(_ month: Date) -> String {
        let startOfMonth = Self.dayDateFormatter.string(from: month.startOfMonth())
        let endOfMonth = Self.dayDateFormatter.string(from: month.endOfMonth())
        let month = "\(startOfMonth) - \(endOfMonth)"
        return month
    }
    
    // MARK: Data
        
    let month: Date
    var isSelected: Bool = false {
        didSet {
            monthCollectionViewCell?.setSelected(isSelected)
        }
    }
    
    // MARK: Initializer
        
    init(month: Date) {
        self.month = month
        super.init()
    }
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
    }
    
    // MARK: Collection View Cell
    
    var monthCollectionViewCell: MonthCollectionViewCell? {
        return collectionViewCell as? MonthCollectionViewCell
    }
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.cellForItemAtIndexPath(indexPath) as! MonthCollectionViewCell
        let startOfMonth = Self.dayDateFormatter.string(from: month.startOfMonth())
        let endOfMonth = Self.dayDateFormatter.string(from: month.endOfMonth())
        let month = "\(startOfMonth) - \(endOfMonth)"
        cell.monthLabel.text = month
        cell.setSelected(isSelected)
        return cell
    }

}
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
