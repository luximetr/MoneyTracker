//
//  AddAccountScreenColorCollectionViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 11.02.2022.
//

import UIKit
import AUIKit

extension AddAccountScreenView {
final class ColorCollectionViewCell: AUICollectionViewCell {
    
    // MARK: Subviews
    
    let colorView = UIView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(colorView)
        setupColorView()
    }
    
    private func setupColorView() {

    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutColorView()
    }
    
    private func layoutColorView() {
        colorView.frame = contentView.bounds
        colorView.layer.cornerRadius = contentView.bounds.width / 2
    }
        
}
}
