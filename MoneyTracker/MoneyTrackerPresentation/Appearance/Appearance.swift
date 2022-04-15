//
//  Appearence.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 15.04.2022.
//

import UIKit

protocol Appearance {
    
    var preferredStatusBarStyle: UIStatusBarStyle { get }
    
    // MARK: - Colors
    
    var primaryBackground: UIColor { get }
    var primaryText: UIColor { get }
    var accent: UIColor { get }
    
}
