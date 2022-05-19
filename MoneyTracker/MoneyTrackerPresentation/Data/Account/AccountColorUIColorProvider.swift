//
//  AccountColorUIColorProvider.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 19.04.2022.
//

import UIKit

class AccountColorUIColorProvider {
    
    func getUIColor(accountColor: AccountColor, appearance: Appearance) -> UIColor {
        switch accountColor {
        case .variant1: return appearance.colors.balanceAccountVariant1PrimaryBackground
        case .variant2: return appearance.colors.balanceAccountVariant2PrimaryBackground
        case .variant3: return appearance.colors.balanceAccountVariant3PrimaryBackground
        case .variant4: return appearance.colors.balanceAccountVariant4PrimaryBackground
        case .variant5: return appearance.colors.balanceAccountVariant5PrimaryBackground
        case .variant6: return appearance.colors.balanceAccountVariant6PrimaryBackground
        case .variant7: return appearance.colors.balanceAccountVariant7PrimaryBackground
        case .variant8: return appearance.colors.balanceAccountVariant8PrimaryBackground
        case .variant9: return appearance.colors.balanceAccountVariant9PrimaryBackground
        case .variant10: return appearance.colors.balanceAccountVariant10PrimaryBackground
        case .variant11: return appearance.colors.balanceAccountVariant11PrimaryBackground
        case .variant12: return appearance.colors.balanceAccountVariant12PrimaryBackground
        case .variant13: return appearance.colors.balanceAccountVariant13PrimaryBackground
        case .variant14: return appearance.colors.balanceAccountVariant14PrimaryBackground
        case .variant15: return appearance.colors.balanceAccountVariant15PrimaryBackground
        case .variant16: return appearance.colors.balanceAccountVariant16PrimaryBackground
        case .variant17: return appearance.colors.balanceAccountVariant17PrimaryBackground
        case .variant18: return appearance.colors.balanceAccountVariant18PrimaryBackground
        case .variant19: return appearance.colors.balanceAccountVariant19PrimaryBackground
        case .variant20: return appearance.colors.balanceAccountVariant20PrimaryBackground
        }
    }
}
