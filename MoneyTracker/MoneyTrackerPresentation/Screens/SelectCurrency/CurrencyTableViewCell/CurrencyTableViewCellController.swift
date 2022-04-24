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
    
    private(set) var appearance: Appearance
    let currency: Currency
    let currencyName: String
    var isSelected: Bool = false {
        didSet { selectCurrencyTableViewCell?.setIsSelected(isSelected) }
    }
    
    init(appearance: Appearance, currency: Currency, currencyName: String, isSelected: Bool) {
        self.appearance = appearance
        self.currency = currency
        self.currencyName = currencyName
        self.isSelected = isSelected
    }
    
    private var selectCurrencyTableViewCell: CurrencyTableViewCell? {
        return tableViewCell as? CurrencyTableViewCell
    }
    
    // MARK: - Create cell
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = super.cellForRowAtIndexPath(indexPath)
        setContent()
        setAppearance(appearance)
        return cell
    }
    
    // MARK: - Content
    
    private func setContent() {
        selectCurrencyTableViewCell?.nameLabel.text = currencyName
        selectCurrencyTableViewCell?.codeLabel.text = currency.rawValue
    }
    
    // MARK: - Appearance
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        selectCurrencyTableViewCell?.setAppearance(appearance)
        selectCurrencyTableViewCell?.setIsSelected(isSelected)
    }
    
}
}
