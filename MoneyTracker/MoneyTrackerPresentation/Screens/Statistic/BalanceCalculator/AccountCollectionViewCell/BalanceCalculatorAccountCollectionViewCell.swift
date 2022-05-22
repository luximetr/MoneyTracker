//
//  BalanceCalculatorAccountCollectionViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 22.05.2022.
//

import UIKit
import AUIKit

extension BalanceCalculatorScreenViewController {
final class AccountCollectionViewCell: AppearanceCollectionViewCell {

    // MARK: Subviews
    
    let nameLabel = UILabel()
    let balanceLabel = UILabel()
    var color: UIColor?
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.35).cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 6
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.addSubview(nameLabel)
        setupNameLabel()
        contentView.addSubview(balanceLabel)
        setupBalanceLabel()
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = appearance?.colors.cardPrimaryText
    }
    
    private func setupBalanceLabel() {
        balanceLabel.textColor = appearance?.colors.cardPrimaryText
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        layoutBalanceLabel()
        layoutNameLabel()
    }
    
    private func layoutBalanceLabel() {
        let height = bounds.height * 0.6
        let possibleWidth = bounds.width * 0.6
        let possibleSize = CGSize(width: possibleWidth, height: height)
        let sizeThatFits = balanceLabel.sizeThatFits(possibleSize)
        let width = sizeThatFits.width
        let y = (bounds.height - height) / 2
        let x = bounds.width - width - 20
        let frame = CGRect(x: x, y: y, width: width, height: height)
        balanceLabel.frame = frame
    }
    
    private func layoutNameLabel() {
        let height = bounds.height * 0.6
        let x: CGFloat = 22
        let y = (bounds.height - height) / 2
        let width = bounds.width - x - (bounds.width - balanceLabel.frame.origin.x) - 12
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nameLabel.frame = frame
    }
    
    override var isHighlighted: Bool {
        willSet {
            if newValue {
                contentView.alpha = 0.6
            } else {
                contentView.alpha = 1
            }
        }
    }
    
    var _isSelected: Bool = false
    func setSelected(_ isSelected: Bool) {
        guard let color = color else { return }
        _isSelected = isSelected
        if _isSelected {
            nameLabel.textColor = appearance?.colors.cardPrimaryText
            balanceLabel.textColor = appearance?.colors.cardPrimaryText
            contentView.backgroundColor = color
            contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.35).cgColor
        } else {
            nameLabel.textColor = color
            balanceLabel.textColor = color
            contentView.backgroundColor = .clear
            contentView.layer.shadowColor = UIColor.clear.cgColor
        }
        contentView.layer.borderColor = color.cgColor
    }
    
    func setColor(_ color: UIColor) {
        self.color = color
        setSelected(_isSelected)
    }
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        nameLabel.textColor = appearance.colors.cardPrimaryText
        balanceLabel.textColor = appearance.colors.cardPrimaryText
    }
        
}
}
