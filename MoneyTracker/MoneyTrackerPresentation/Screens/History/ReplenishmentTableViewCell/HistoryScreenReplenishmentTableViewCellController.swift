//
//  ReplenishmentTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import UIKit
import AUIKit

extension HistoryScreenViewController {
final class ReplenishmentTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: - Data
    
    private var language: Language
    var replenishment: Replenishment
    
    // MARK: - Initializer
    
    init(language: Language, replenishment: Replenishment) {
        self.language = language
        self.replenishment = replenishment
    }
    
    // MARK: - Cell
    
    private var replenishmentTableViewCell: ReplenishmentTableViewCell? {
        return tableViewCell as? ReplenishmentTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let balanceReplenishmentTableViewCell = super.cellForRowAtIndexPath(indexPath) as? ReplenishmentTableViewCell else { return UITableViewCell() }
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
        let name = replenishment.account.name
        replenishmentTableViewCell?.accountLabel.text = name
        let amount = "\(Self.amountNumberFormatter.string(for: replenishment.amount) ?? "") \(currencyCodeLocalizer.code(replenishment.account.currency))"
        replenishmentTableViewCell?.amountLabel.text = amount
        let comment = replenishment.comment
        replenishmentTableViewCell?.commentLabel.text = comment
    }
    
}
}
