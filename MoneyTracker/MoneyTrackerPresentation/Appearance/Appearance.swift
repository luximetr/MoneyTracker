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
    var primaryText: UIColor { get }
    var secondaryText: UIColor { get }
    var accent: UIColor { get }
    
}
