//
//  Appearence.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 15.04.2022.
//

import UIKit

protocol Appearance {
    
    var statusBarStyle: UIStatusBarStyle { get }
    
    // MARK: - Colors
    
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
    
}
