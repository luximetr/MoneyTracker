//
//  AddCollectionViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 29.03.2022.
//

import UIKit
import AUIKit
import PinLayout

extension CategoryHorizontalPickerController {
class AddCollectionViewCell: AppearanceCollectionViewCell {
    
    // MARK: Subviews
    
    let textLabel = UILabel()
    private let borderLayer = CAShapeLayer()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        contentView.layer.addSublayer(borderLayer)
        setupBorderLayer()
        contentView.addSubview(textLabel)
        setupTextLabel()
    }
    
    private func setupBorderLayer() {
        borderLayer.strokeColor = appearance?.secondaryBackground.cgColor
        borderLayer.fillColor = nil
    }
    
    private func setupTextLabel() {
        textLabel.font = Fonts.default(size: 12, weight: .regular)
        textLabel.textColor = appearance?.secondaryText
        textLabel.textAlignment = .center
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBorderLayer()
        layoutTextLabel()
    }
    
    private func layoutBorderLayer() {
        borderLayer.frame = bounds
        borderLayer.lineDashPattern = [2, 2]
        let bezierPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2)
        borderLayer.path = bezierPath.cgPath
    }
    
    private func layoutTextLabel() {
        textLabel.frame = bounds
        textLabel.textAlignment = .center
    }
    
    // MARK: Size
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = textLabel.sizeThatFits(size)
        sizeThatFits.width += 12 * 2
        sizeThatFits.height += 8
        return sizeThatFits
    }
    
    private static let addCollectionViewCell = AddCollectionViewCell(frame: .zero)
    static func sizeThatFits(_ size: CGSize, text: String) -> CGSize {
        addCollectionViewCell.textLabel.text = text
        let sizeThatFits = addCollectionViewCell.sizeThatFits(size)
        return sizeThatFits
    }
    
    // MARK: States
    
    override var isHighlighted: Bool {
        willSet {
            if newValue {
                borderLayer.opacity = 0.4
                textLabel.alpha = 0.6
            } else {
                borderLayer.opacity = 1
                textLabel.alpha = 1
            }
        }
    }
    
    // MARK: Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        setupBorderLayer()
        setupTextLabel()
    }
    
}
}
