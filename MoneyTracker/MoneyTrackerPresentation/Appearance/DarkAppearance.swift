//
//  DarkAppearance.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 15.04.2022.
//

import UIKit

struct DarkAppearance: Appearance {
    
    let statusBarStyle = UIStatusBarStyle.lightContent
    
    // MARK: - Colors
    
    let primaryBackground = UIColor(red: 0.106, green: 0.11, blue: 0.118, alpha: 1)
    let secondaryBackground = UIColor(red: 0.158, green: 0.158, blue: 0.158, alpha: 1)
    let tertiaryBackground = UIColor(red: 0.349, green: 0.349, blue: 0.349, alpha: 1)
    let selectedBackground = UIColor(red: 0.093, green: 0.212, blue: 0.392, alpha: 1)
    let dangerousActionBackground = UIColor(red: 0.65, green: 0.184, blue: 0.184, alpha: 1)
    let dangerousActionText = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
    let primaryActionBackground = UIColor(red: 0.167, green: 0.404, blue: 0.758, alpha: 1)
    let primaryActionText = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    let primaryActionBackgroundDisabled = UIColor(red: 0.632, green: 0.671, blue: 0.729, alpha: 1)
    let primaryActionTextDisabled = UIColor(red: 0.942, green: 0.942, blue: 0.942, alpha: 1)
    let successActionBackground = UIColor(red: 0.205, green: 0.646, blue: 0.355, alpha: 1)
    let successActionText = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    let accent = UIColor(red: 0.429, green: 0.657, blue: 1, alpha: 1)
    let primaryText = UIColor(red: 0.977, green: 0.977, blue: 0.977, alpha: 1)
    let secondaryText = UIColor(red: 0.658, green: 0.658, blue: 0.658, alpha: 1)
    let tertiaryText = UIColor(red: 0.383, green: 0.383, blue: 0.383, alpha: 1)
    let successText = UIColor(red: 0.214, green: 0.817, blue: 0.347, alpha: 1)
    let dangerousText = UIColor(red: 0.922, green: 0.341, blue: 0.341, alpha: 1)
    let transparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
}
