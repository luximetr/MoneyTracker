//
//  TransferAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 21.04.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias PresentationTransfer = MoneyTrackerPresentation.Transfer
typealias StorageBalanceTransfer = MoneyTrackerStorage.Transfer
typealias StorageBalanceReplenishment = MoneyTrackerStorage.Replenishment
typealias PresentationEditingTransfer = MoneyTrackerPresentation.EditingTransfer
typealias StorageEditingTransfer = MoneyTrackerStorage.EditingTransfer

class TransferAdapter {
    
    func adaptToPresentation(
        storageTransfer: StorageBalanceTransfer,
        fromPresentationAccount: PresentationBalanceAccount,
        toPresentationAccount: PresentationBalanceAccount
    ) -> PresentationTransfer {
        return PresentationTransfer(
            id: storageTransfer.id,
            fromAccount: fromPresentationAccount,
            toAccount: toPresentationAccount,
            day: storageTransfer.date,
            fromAmount: storageTransfer.fromAmount,
            toAmount: storageTransfer.toAmount,
            comment: storageTransfer.comment
        )
    }
}
