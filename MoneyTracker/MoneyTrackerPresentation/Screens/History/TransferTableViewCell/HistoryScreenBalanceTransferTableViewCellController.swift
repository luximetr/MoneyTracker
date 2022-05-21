//
//  BalanceTransferTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import UIKit
import AUIKit

extension HistoryScreenViewController {
final class TransferTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: - Data
    
    var locale: Locale
    var transfer: Transfer
    
    // MARK: - Initializer
    
    init(locale: Locale, transfer: Transfer) {
        self.locale = locale
        self.transfer = transfer
    }
    
    // MARK: - Cell
    
    private var transferTableViewCell: TransferTableViewCell? {
        return tableViewCell as? TransferTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let balanceReplenishmentTableViewCell = super.cellForRowAtIndexPath(indexPath) as? TransferTableViewCell else { return UITableViewCell() }
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
        let localizer = CurrencyCodeLocalizer(language: locale.language)
        return localizer
    }()
    
    private func setContent() {
        let fromAccount = transfer.fromAccount.name
        transferTableViewCell?.fromAccountLabel.text = fromAccount
        let toAccount = transfer.toAccount.name
        transferTableViewCell?.toAccountLabel.text = toAccount
        let fromAmount = "\(Self.amountNumberFormatter.string(for: transfer.fromAmount) ?? "") \(currencyCodeLocalizer.code(transfer.fromAccount.currency))"
        transferTableViewCell?.fromAmountLabel.text = fromAmount
        transferTableViewCell?.commentLabel.text = transfer.comment
    }
    
}
}
