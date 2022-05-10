//
//  Operation.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationOperation = MoneyTrackerPresentation.Operation
import MoneyTrackerStorage
typealias StorageOperation = MoneyTrackerStorage.Operation

class OperationAdapter {
    
    func adaptToStorage(filesImportingOperation: FilesImportingBalanceAccountOperation) -> StorageOperation {
        switch filesImportingOperation.operationType {
            case .expense: fatalError()
            case .transfer: fatalError()
            case .replenishment: fatalError()
        }
        fatalError()
    }
}
