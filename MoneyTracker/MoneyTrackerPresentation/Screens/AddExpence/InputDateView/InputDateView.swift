//
//  InputDateView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

import UIKit
import AUIKit

final class InputDateView: AUIView {
    
    // MARK: Subviews
    
    let button = UIButton()
    let datePicker = UIDatePicker()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        addSubview(button)
        addSubview(datePicker)
        datePicker.alpha = 0.1
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutButton()
        layoutDatePicker()
    }
    
    private func layoutButton() {
        let x: CGFloat = 0
        let y: CGFloat = 0
        let width = bounds.width
        let height = bounds.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        button.frame = frame
    }
    
    private func layoutDatePicker() {
        let x: CGFloat = 0
        let y: CGFloat = 0
        let width = bounds.width
        let height = bounds.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        datePicker.frame = frame
    }
    
}

