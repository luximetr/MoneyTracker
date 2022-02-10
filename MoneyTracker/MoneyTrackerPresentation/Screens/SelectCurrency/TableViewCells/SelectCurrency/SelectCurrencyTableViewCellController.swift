//
//  SelectCurrencyTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 10.02.2022.
//

import UIKit
import AUIKit

final class SelectCurrencyTableViewCellController: AUIClosuresTableViewCellController {
    
    let currency: Currency
    var isSelected: Bool = false {
        didSet { selectCurrencyTableViewCell?.isSelected = isSelected }
    }
    
    init(currency: Currency, isSelected: Bool) {
        self.currency = currency
        self.isSelected = isSelected
    }
    
    var tableViewCell: UITableViewCell?
    private var selectCurrencyTableViewCell: SelectCurrencyTableViewCell? {
        return tableViewCell as? SelectCurrencyTableViewCell
    }
    
    // MARK: -
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = super.cellForRowAtIndexPath(indexPath)
        self.tableViewCell = tableViewCell
        return tableViewCell
    }
    
    override func didEndDisplayingCell() {
        self.tableViewCell = nil
        super.didEndDisplayingCell()
    }
}
