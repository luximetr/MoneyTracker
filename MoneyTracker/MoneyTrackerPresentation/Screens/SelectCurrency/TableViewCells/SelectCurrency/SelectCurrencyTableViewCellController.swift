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
    
    private var selectCurrencyTableViewCell: SelectCurrencyTableViewCell? {
        return tableViewCell as? SelectCurrencyTableViewCell
    }
    
}
