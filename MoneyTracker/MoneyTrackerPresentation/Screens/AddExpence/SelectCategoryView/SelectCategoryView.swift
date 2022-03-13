//
//  SelectCategoryView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 12.03.2022.
//

import UIKit
import AUIKit

final class SelectCategoryView: AUIView {
    
    // MARK: Subviews
    
    let pickerView = UIPickerView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.secondaryBackground
        clipsToBounds = true
        addSubview(pickerView)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layoutPickerView()
    }
    
    private func layoutPickerView() {
        let x: CGFloat = 0
        let y: CGFloat = 0
        let width = bounds.width
        let height = bounds.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        pickerView.frame = frame
    }
    
}
