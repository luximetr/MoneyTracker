//
//  InputDateView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

import UIKit
import AUIKit

final class InputDateView: AppearanceView {
    
    // MARK: Subviews
    
    let datePicker = UIDatePicker()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        addSubview(datePicker)
        autoLayout()
        setAppearance(appearance)
    }
    
    // MARK: AutoLayout
    
    private func autoLayout() {
        autoLayoutDatePicker()
    }
    
    private func autoLayoutDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        datePicker.overrideUserInterfaceStyle = appearance.colors.overrideUserInterfaceStyle
    }
    
}

