//
//  AddingTopUpAccount.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 07.04.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationAddingTopUpAccount = MoneyTrackerPresentation.AddingTopUpAccount

struct AddingTopUpAccount: Hashable, Equatable {
    
    let account: Account
    let day: Date
    let amount: Decimal
    let comment: String?
    
    // MARK: PresentationAddingTransfer
    
    init(presentationAddingTopUpAccount: PresentationAddingTopUpAccount) throws {
        do {
            self.account = try Account(presentationAccount: presentationAddingTopUpAccount.account)
            self.day = presentationAddingTopUpAccount.day
            self.amount = presentationAddingTopUpAccount.amount
            self.comment = presentationAddingTopUpAccount.comment
        } catch {
            let error = Error("Cannot initialize \(Self.self) from \(presentationAddingTopUpAccount)\n\(error)")
            throw error
        }
    }
    
    func presentationAddingTopUpAccount() throws -> PresentationAddingTopUpAccount {
        do {
            let account = try self.account.presentationAccount()
            let day = self.day
            let amount = self.amount
            let comment = self.comment
            let presentationAddingTopUpAccount = PresentationAddingTopUpAccount(account: account, day: day, amount: amount, comment: comment)
            return presentationAddingTopUpAccount
        } catch {
            let error = Error("Cannot create \(PresentationAddingTopUpAccount.self) from \(self)\n\(error)")
            throw error
        }
    }
    
}
