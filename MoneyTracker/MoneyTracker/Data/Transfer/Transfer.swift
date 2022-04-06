//
//  Transfer.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 06.04.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationTransfer = MoneyTrackerPresentation.Transfer

struct Transfer: Hashable, Equatable {
    
    let id: String
    let fromAccount: Account
    let toAccount: Account
    let day: Date
    let fromAmount: Decimal
    let toAmount: Decimal
    let comment: String?
    
    // MARK: PresentationTransfer
    
    init(presentationTransfer: PresentationTransfer) throws {
        do {
            self.id = presentationTransfer.id
            self.fromAccount = try Account(presentationAccount: presentationTransfer.fromAccount)
            self.toAccount = try Account(presentationAccount: presentationTransfer.toAccount)
            self.day = presentationTransfer.day
            self.fromAmount = presentationTransfer.fromAmount
            self.toAmount = presentationTransfer.toAmount
            self.comment = presentationTransfer.comment
        } catch {
            let error = Error("Cannot initialize \(Self.self) from \(presentationTransfer)\n\(error)")
            throw error
        }
    }
    
    func presentationTransfer() throws -> PresentationTransfer {
        do {
            let id = self.id
            let fromAccount = try self.fromAccount.presentationAccount()
            let toAccount = try self.toAccount.presentationAccount()
            let day = self.day
            let fromAmount = self.fromAmount
            let toAmount = self.toAmount
            let comment = self.comment
            let presentationTransfer = PresentationTransfer(id: id, fromAccount: fromAccount, toAccount: toAccount, day: day, fromAmount: fromAmount, toAmount: toAmount, comment: comment)
            return presentationTransfer
        } catch {
            let error = Error("Cannot create \(PresentationTransfer.self) from \(self)\n\(error)")
            throw error
        }
    }
    
}
