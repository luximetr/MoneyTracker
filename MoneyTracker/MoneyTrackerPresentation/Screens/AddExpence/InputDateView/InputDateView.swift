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
    
    let datePicker = UIDatePicker()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        addSubview(datePicker)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutDatePicker()
    }
    
    private func layoutDatePicker() {
        let x: CGFloat = 16
        let possibleWidth = bounds.width - 2 * x
        let possibleHeight = bounds.height
        let sizeThatFits = datePicker.sizeThatFits(CGSize(width: possibleWidth, height: possibleHeight))
        let width = sizeThatFits.width
        let height = sizeThatFits.height
        let y: CGFloat = (bounds.size.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        datePicker.frame = frame
    }
    
}

