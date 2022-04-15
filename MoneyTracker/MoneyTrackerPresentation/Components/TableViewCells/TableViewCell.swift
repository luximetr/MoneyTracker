//
//  TableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 15.04.2022.
//

import UIKit
import AUIKit

class TableViewCell: AUITableViewCell {
    
    // MARK: - Appearance
    
    private var appearance: Appearance?
    
    // MARK: - Setup
    
    func setup(appearance: Appearance) {
        backgroundColor = appearance.primaryBackground
    }
    
}
