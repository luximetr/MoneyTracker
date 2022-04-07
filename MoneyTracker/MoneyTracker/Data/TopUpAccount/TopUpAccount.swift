//
//  TopUpAccount.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 07.04.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationTopUpAccount = MoneyTrackerPresentation.TopUpAccount

struct TopUpAccount: Hashable, Equatable {
    
    let id: String
    let account: Account
    let day: Date
    let amount: Decimal
    let comment: String?
    
    // MARK: PresentationAddingTransfer
    
    init(presentationTopUpAccount: PresentationTopUpAccount) throws {
        do {
            self.id = presentationTopUpAccount.id
            self.account = try Account(presentationAccount: presentationTopUpAccount.account)
            self.day = presentationTopUpAccount.day
            self.amount = presentationTopUpAccount.amount
            self.comment = presentationTopUpAccount.comment
        } catch {
            let error = Error("Cannot initialize \(Self.self) from \(presentationTopUpAccount)\n\(error)")
            throw error
        }
    }
    
    func presentationTopUpAccount() throws -> PresentationTopUpAccount {
        do {
            let id = self.id
            let account = try self.account.presentationAccount()
            let day = self.day
            let amount = self.amount
            let comment = self.comment
            let presentationTopUpAccount = PresentationTopUpAccount(id: id, account: account, day: day, amount: amount, comment: comment)
            return presentationTopUpAccount
        } catch {
            let error = Error("Cannot create \(PresentationAddingTopUpAccount.self) from \(self)\n\(error)")
            throw error
        }
    }
    
}
