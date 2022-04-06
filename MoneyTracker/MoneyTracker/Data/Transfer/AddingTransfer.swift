//
//  AddingTransfer.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 06.04.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationAddingTransfer = MoneyTrackerPresentation.AddingTransfer

struct AddingTransfer: Hashable, Equatable {
    
    let fromAccount: Account
    let toAccount: Account
    let day: Date
    let fromAmount: Decimal
    let toAmount: Decimal
    let comment: String?
    
    // MARK: PresentationAddingTransfer
    
    init(presentationAddingTransfer: PresentationAddingTransfer) throws {
        do {
            self.fromAccount = try Account(presentationAccount: presentationAddingTransfer.fromAccount)
            self.toAccount = try Account(presentationAccount: presentationAddingTransfer.toAccount)
            self.day = presentationAddingTransfer.day
            self.fromAmount = presentationAddingTransfer.fromAmount
            self.toAmount = presentationAddingTransfer.toAmount
            self.comment = presentationAddingTransfer.comment
        } catch {
            let error = Error("Cannot initialize \(Self.self) from \(presentationAddingTransfer)\n\(error)")
            throw error
        }
    }
    
    func presentationAddingTransfer() throws -> PresentationAddingTransfer {
        do {
            let fromAccount = try self.fromAccount.presentationAccount()
            let toAccount = try self.toAccount.presentationAccount()
            let day = self.day
            let fromAmount = self.fromAmount
            let toAmount = self.toAmount
            let comment = self.comment
            let presentationAddingTransfer = PresentationAddingTransfer(fromAccount: fromAccount, toAccount: toAccount, day: day, fromAmount: fromAmount, toAmount: toAmount, comment: comment)
            return presentationAddingTransfer
        } catch {
            let error = Error("Cannot create \(PresentationAddingTransfer.self) from \(self)\n\(error)")
            throw error
        }
    }
    
}
