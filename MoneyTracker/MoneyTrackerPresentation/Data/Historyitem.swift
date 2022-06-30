//
//  Historyitem.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.06.2022.
//

public enum Historyitem: Hashable, Equatable {
    case day(Date, CurrenciesAmount)
    case expense(Expense)
    case transfer(Transfer)
    case replenishment(Replenishment)
}
