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
        colorView.frame = contentView.bounds
        colorView.layer.cornerRadius = contentView.bounds.width / 2
    }
    
    private func layoutCheckImageView() {
        let x: CGFloat = 9
        let y: CGFloat = 11
        let width: CGFloat = 18
        let height: CGFloat = 14
        let frame = CGRect(x: x, y: y, width: width, height: height)
        checkImageView.frame = frame
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
