//
//  TableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 15.04.2022.
//

import UIKit
import AUIKit

class AppearanceTableViewCell: AUITableViewCell {
    
    // MARK: - Appearance
    
    var appearance: Appearance?
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
    }

}
