//
//  CategoryColorUIColorProvider.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 19.04.2022.
//

import UIKit

class CategoryColorUIColorProvider {
    
    func getUIColor(categoryColor: CategoryColor, appearance: Appearance) -> UIColor {
        switch categoryColor {
            case .variant1: return appearance.categoryVariant1PrimaryBackground
            case .variant2: return appearance.categoryVariant2PrimaryBackground
            case .variant3: return appearance.categoryVariant3PrimaryBackground
            case .variant4: return appearance.categoryVariant4PrimaryBackground
            case .variant5: return appearance.categoryVariant5PrimaryBackground
            case .variant6: return appearance.categoryVariant6PrimaryBackground
            case .variant7: return appearance.categoryVariant7PrimaryBackground
            case .variant8: return appearance.categoryVariant8PrimaryBackground
            case .variant9: return appearance.categoryVariant9PrimaryBackground
            case .variant10: return appearance.categoryVariant10PrimaryBackground
            case .variant11: return appearance.categoryVariant11PrimaryBackground
            case .variant12: return appearance.categoryVariant12PrimaryBackground
            case .variant13: return appearance.categoryVariant13PrimaryBackground
            case .variant14: return appearance.categoryVariant14PrimaryBackground
            case .variant15: return appearance.categoryVariant15PrimaryBackground
            case .variant16: return appearance.categoryVariant16PrimaryBackground
            case .variant17: return appearance.categoryVariant17PrimaryBackground
            case .variant18: return appearance.categoryVariant18PrimaryBackground
            case .variant19: return appearance.categoryVariant19PrimaryBackground
        }
    }
}
