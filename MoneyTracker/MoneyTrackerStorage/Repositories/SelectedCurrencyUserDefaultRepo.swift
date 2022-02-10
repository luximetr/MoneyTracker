//
//  SelectedCurrencyUserDefaultRepo.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 10.02.2022.
//

import Foundation

class SelectedCurrencyUserDefaultRepo {
    
    // MARK: - Dependencies
    
    private let userDefautlsAccessor: UserDefaultsAccessor
    private let key = "selectedCurrency"
    
    // MARK: - Life cycle
    
    init(userDefautlsAccessor: UserDefaultsAccessor) {
        self.userDefautlsAccessor = userDefautlsAccessor
    }
    
    // MARK: - Save
    
    func save(currency: Currency) {
        userDefautlsAccessor.userDefaults.set(currency.rawValue, forKey: key)
    }
    
    // MARK: - Fetch
    
    func fetch() throws -> Currency {
        guard let rawValue = userDefautlsAccessor.userDefaults.string(forKey: key) else {
            throw FetchError.notFound
        }
        return try Currency(rawValue)
    }
    
    // MARK: - Error
    
    enum FetchError: Error {
        case notFound
    }
}
