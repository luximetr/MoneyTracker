//
//  ExpenseAddedSnackbarView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 23.03.2022.
//

import UIKit
import AUIKit

final class ExpenseAddedSnackbarView: AUIView {
    
    // MARK: Subviews
    
    let messageLabel = UILabel()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.greenCardSecondaryBackground
        addSubview(messageLabel)
        setupMessageLabel()
    }
    
    private func setupMessageLabel() {
        
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layoutMessageLabel()
    }
    
    private func layoutMessageLabel() {
        let x: CGFloat = 16
        let y: CGFloat = 0
        let width = bounds.width - 2 * x
        let height = bounds.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        messageLabel.frame = frame
    }
    
    // MARK: Size
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width = size.width
        let height: CGFloat = 44
        let sizeThatFits = CGSize(width: width, height: height)
        return sizeThatFits
    }
    
}
