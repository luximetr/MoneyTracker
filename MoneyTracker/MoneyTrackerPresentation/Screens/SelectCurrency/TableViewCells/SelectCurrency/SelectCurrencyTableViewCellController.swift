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
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    var tableViewCell: UITableViewCell?
    
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
