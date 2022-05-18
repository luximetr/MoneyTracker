//
//  AppearanceColors.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 17.05.2022.
//

import UIKit

protocol AppearanceColors {
    
    var primaryBackground: UIColor { get }
    var secondaryBackground: UIColor { get }
    var tertiaryBackground: UIColor { get }
    var selectedBackground: UIColor { get }
    var primaryActionBackground: UIColor { get }
    var primaryActionText: UIColor { get }
    var primaryActionBackgroundDisabled: UIColor { get }
    var primaryActionTextDisabled: UIColor { get }
    var successActionBackground: UIColor { get }
    var successActionText: UIColor { get }
    var dangerousActionBackground: UIColor { get }
    var dangerousActionText: UIColor { get }
    var accent: UIColor { get }
    var primaryText: UIColor { get }
    var secondaryText: UIColor { get }
    var tertiaryText: UIColor { get }
    var successText: UIColor { get }
    var dangerousText: UIColor { get }
    var transparent: UIColor { get }
    var balanceAccountPrimaryText: UIColor { get }
    var balanceAccountSecondaryText: UIColor { get }
    var categoryPrimaryText: UIColor { get }
    var cardPrimaryText: UIColor { get }
    
}
