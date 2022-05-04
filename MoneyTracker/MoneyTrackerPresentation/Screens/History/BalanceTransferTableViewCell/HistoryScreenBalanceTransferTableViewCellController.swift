//
//  BalanceTransferTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import UIKit
import AUIKit

extension HistoryScreenViewController {
final class BalanceTransferTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: - Data
    
    var language: Language
    var balanceTransfer: Transfer
    
    // MARK: - Initializer
    
    init(language: Language, balanceTransfer: Transfer) {
        self.language = language
        self.balanceTransfer = balanceTransfer
    }
    
    // MARK: - Cell
    
    private var balanceTransferTableViewCell: BalanceTransferTableViewCell? {
        return tableViewCell as? BalanceTransferTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let balanceReplenishmentTableViewCell = super.cellForRowAtIndexPath(indexPath) as? BalanceTransferTableViewCell else { return UITableViewCell() }
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
        let fromAccount = balanceTransfer.fromAccount.name
        balanceTransferTableViewCell?.fromAccountLabel.text = fromAccount
        let toAccount = balanceTransfer.toAccount.name
        balanceTransferTableViewCell?.toAccountLabel.text = toAccount
        let fromAmount = "\(Self.amountNumberFormatter.string(for: balanceTransfer.fromAmount) ?? "") \(currencyCodeLocalizer.code(balanceTransfer.fromAccount.currency))"
        balanceTransferTableViewCell?.fromAmountLabel.text = fromAmount
        balanceTransferTableViewCell?.commentLabel.text = balanceTransfer.comment
    }
    
}
}
