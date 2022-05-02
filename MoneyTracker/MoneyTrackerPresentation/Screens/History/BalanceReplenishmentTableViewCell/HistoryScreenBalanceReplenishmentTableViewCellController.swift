//
//  BalanceReplenishmentTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import UIKit
import AUIKit

extension HistoryScreenViewController {
final class BalanceReplenishmentTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: - Data
    
    private var language: Language
    var balanceReplenishment: BalanceReplenishment
    
    // MARK: - Initializer
    
    init(language: Language, balanceReplenishment: BalanceReplenishment) {
        self.language = language
        self.balanceReplenishment = balanceReplenishment
    }
    
    // MARK: - Cell
    
    private var balanceReplenishmentTableViewCell: BalanceReplenishmentTableViewCell? {
        return tableViewCell as? BalanceReplenishmentTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let balanceReplenishmentTableViewCell = super.cellForRowAtIndexPath(indexPath) as? BalanceReplenishmentTableViewCell else { return UITableViewCell() }
        setContent()
        return balanceReplenishmentTableViewCell
    }
    
    // MARK: - Content
    
    private static let amountNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    private lazy var currencyCodeLocalizer: CurrencyCodeLocalizer = {
        let localizer = CurrencyCodeLocalizer(language: language)
        return localizer
    }()
    
    private func setContent() {
        let name = balanceReplenishment.balanceAccount.name
        balanceReplenishmentTableViewCell?.accountLabel.text = name
        let amount = "\(Self.amountNumberFormatter.string(for: balanceReplenishment.amount) ?? "") \(currencyCodeLocalizer.code(balanceReplenishment.balanceAccount.currency))"
        balanceReplenishmentTableViewCell?.amountLabel.text = amount
        let comment = balanceReplenishment.comment
        balanceReplenishmentTableViewCell?.commentLabel.text = comment
    }
    
}
}
