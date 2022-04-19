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
            case .variant1: return appearance.balanceAccountVariant1PrimaryBackground
            case .variant2: return appearance.balanceAccountVariant2PrimaryBackground
            case .variant3: return appearance.balanceAccountVariant3PrimaryBackground
            case .variant4: return appearance.balanceAccountVariant4PrimaryBackground
            case .variant5: return appearance.balanceAccountVariant5PrimaryBackground
            case .variant6: return appearance.balanceAccountVariant6PrimaryBackground
            case .variant7: return appearance.balanceAccountVariant7PrimaryBackground
            case .variant8: return appearance.balanceAccountVariant8PrimaryBackground
            case .variant9: return appearance.balanceAccountVariant9PrimaryBackground
            case .variant10: return appearance.balanceAccountVariant10PrimaryBackground
            case .variant11: return appearance.balanceAccountVariant11PrimaryBackground
            case .variant12: return appearance.balanceAccountVariant12PrimaryBackground
            case .variant13: return appearance.balanceAccountVariant13PrimaryBackground
            case .variant14: return appearance.balanceAccountVariant14PrimaryBackground
            case .variant15: return appearance.balanceAccountVariant15PrimaryBackground
            case .variant16: return appearance.balanceAccountVariant16PrimaryBackground
            case .variant17: return appearance.balanceAccountVariant17PrimaryBackground
            case .variant18: return appearance.balanceAccountVariant18PrimaryBackground
            case .variant19: return appearance.balanceAccountVariant19PrimaryBackground
            case .variant20: return appearance.balanceAccountVariant20PrimaryBackground
        }
    }
}
