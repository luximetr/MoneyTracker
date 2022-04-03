//
//  ColorHorizontalPickerColorCell.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.04.2022.
//

import UIKit
import AUIKit
import PinLayout

extension ColorHorizontalPickerView {
final class ColorCell: AUICollectionViewCell {
    
    // MARK: Subviews
    
    let colorView = UIView()
    let checkImageView = UIImageView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(colorView)
        setupColorView()
        contentView.addSubview(checkImageView)
        setupCheckImageView()
    }
    
    private func setupColorView() {

    }
    
    private func setupCheckImageView() {
        checkImageView.contentMode = .scaleAspectFit
        checkImageView.image = Images.check
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutColorView()
        layoutCheckImageView()
    }
    
    private func layoutColorView() {
        colorView.pin.all()
        colorView.layer.cornerRadius = colorView.bounds.height / 2
    }
    
    private func layoutCheckImageView() {
        checkImageView.pin
            .vCenter()
            .hCenter()
            .width(18)
            .height(14)
    }
    
    // MARK: Selected
    
    func setIsSelected(_ isSelected: Bool, animated: Bool) {
        if isSelected {
            checkImageView.isHidden = false
        } else {
            checkImageView.isHidden = true
        }
    }
}
}
