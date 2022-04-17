//
//  AppearanceCollectionViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 17.04.2022.
//

import UIKit
import AUIKit

class AppearanceCollectionViewCell: AUICollectionViewCell {
    
    // MARK: - Appearance
    
    var appearance: Appearance?
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
    }

}
