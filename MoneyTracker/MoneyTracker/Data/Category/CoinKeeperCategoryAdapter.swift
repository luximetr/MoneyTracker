//
//  CoinKeeperCategoryAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 06.03.2022.
//

import Foundation
import MoneyTrackerFiles

typealias FilesCoinKeeperCategory = MoneyTrackerFiles.CoinKeeperCategory

class CoinKeeperCategoryAdapter {
    
    func adaptToStorageAdding(filesCoinKeeperCategory: FilesCoinKeeperCategory) -> StorageAddingCategory {
        return StorageAddingCategory(name: filesCoinKeeperCategory.name)
    }
}
