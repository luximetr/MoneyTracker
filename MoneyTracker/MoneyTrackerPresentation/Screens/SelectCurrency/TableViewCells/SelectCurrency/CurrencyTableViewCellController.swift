//
//  SelectCurrencyTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 10.02.2022.
//

import UIKit
import AUIKit

extension SelectCurrencyScreenViewController {
final class CurrencyTableViewCellController: AUIClosuresTableViewCellController {
    
    let currency: Currency
    var isSelected: Bool = false {
        didSet { selectCurrencyTableViewCell?.isSelected = isSelected }
    }
    
    init(currency: Currency, isSelected: Bool) {
        self.currency = currency
        self.isSelected = isSelected
    }
    
    private var selectCurrencyTableViewCell: CurrencyTableViewCell? {
        return tableViewCell as? CurrencyTableViewCell
    }
    
}
}
