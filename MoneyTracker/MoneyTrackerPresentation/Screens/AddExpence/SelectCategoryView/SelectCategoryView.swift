//
//  SelectCategoryView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 12.03.2022.
//

import UIKit
import AUIKit

extension AddExpenseScreenViewController {
final class SelectCategoryView: AUIView {
    
    // MARK: Subviews
    
    let pickerView = UIPickerView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.white
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addSubview(pickerView)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutPickerView()
    }
    
    private func layoutPickerView() {
        let x: CGFloat = 0
        let y: CGFloat = 0
        let width = bounds.width
        let height = bounds.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        pickerView.frame = frame
        layer.cornerRadius = 10
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.cornerRadius = 10
    }
    
}
}
