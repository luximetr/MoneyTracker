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
            case .variant1: return appearance.colors.categoryVariant1PrimaryBackground
            case .variant2: return appearance.colors.categoryVariant2PrimaryBackground
            case .variant3: return appearance.colors.categoryVariant3PrimaryBackground
            case .variant4: return appearance.colors.categoryVariant4PrimaryBackground
            case .variant5: return appearance.colors.categoryVariant5PrimaryBackground
            case .variant6: return appearance.colors.categoryVariant6PrimaryBackground
            case .variant7: return appearance.colors.categoryVariant7PrimaryBackground
            case .variant8: return appearance.colors.categoryVariant8PrimaryBackground
            case .variant9: return appearance.colors.categoryVariant9PrimaryBackground
            case .variant10: return appearance.colors.categoryVariant10PrimaryBackground
            case .variant11: return appearance.colors.categoryVariant11PrimaryBackground
            case .variant12: return appearance.colors.categoryVariant12PrimaryBackground
            case .variant13: return appearance.colors.categoryVariant13PrimaryBackground
            case .variant14: return appearance.colors.categoryVariant14PrimaryBackground
            case .variant15: return appearance.colors.categoryVariant15PrimaryBackground
            case .variant16: return appearance.colors.categoryVariant16PrimaryBackground
            case .variant17: return appearance.colors.categoryVariant17PrimaryBackground
            case .variant18: return appearance.colors.categoryVariant18PrimaryBackground
            case .variant19: return appearance.colors.categoryVariant19PrimaryBackground
        }
    }
}
