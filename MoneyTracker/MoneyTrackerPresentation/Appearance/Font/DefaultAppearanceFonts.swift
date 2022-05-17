//
//  DefaultAppearanceFonts.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 17.05.2022.
//

import UIKit

class DefaultAppearanceFonts: AppearanceFonts {
    
    func primary(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    
}
