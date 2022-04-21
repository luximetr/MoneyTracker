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
    
    func fetch() throws -> Currency? {
        guard let rawValue = userDefautlsAccessor.userDefaults.string(forKey: key) else {
            return nil
        }
        return try Currency(rawValue)
    }
    
    // MARK: - Error
    
    enum FetchError: Swift.Error {
        case notFound
    }
}

class SelectedLanguageUserDefaultRepo {
    
    // MARK: - Dependencies
    
    private let userDefautlsAccessor: UserDefaultsAccessor
    private let key = "selectedLanguage"
    
    // MARK: - Life cycle
    
    init(userDefautlsAccessor: UserDefaultsAccessor) {
        self.userDefautlsAccessor = userDefautlsAccessor
    }
    
    // MARK: - Save
    
    func save(language: Language) {
        userDefautlsAccessor.userDefaults.set(language.rawValue, forKey: key)
    }
    
    // MARK: - Fetch
    
    func fetch() throws -> Language? {
        guard let rawValue = userDefautlsAccessor.userDefaults.string(forKey: key) else {
            return nil
        }
        return Language(rawValue: rawValue)
    }
    
    // MARK: - Error
    
    enum FetchError: Swift.Error {
        case notFound
    }
}

class SelectedAppearanceSettingUserDefaultRepo {
    
    // MARK: - Dependencies
    
    private let userDefautlsAccessor: UserDefaultsAccessor
    private let key = "selectedAppearanceSetting"
    
    // MARK: - Life cycle
    
    init(userDefautlsAccessor: UserDefaultsAccessor) {
        self.userDefautlsAccessor = userDefautlsAccessor
    }
    
    // MARK: - Save
    
    func save(appearanceSetting: AppearanceSetting) {
        userDefautlsAccessor.userDefaults.set(appearanceSetting.rawValue, forKey: key)
    }
    
    // MARK: - Fetch
    
    func fetch() throws -> AppearanceSetting? {
        guard let rawValue = userDefautlsAccessor.userDefaults.string(forKey: key) else {
            return nil
        }
        return AppearanceSetting(rawValue: rawValue)
    }
    
    // MARK: - Error
    
    enum FetchError: Swift.Error {
        case notFound
    }
}
