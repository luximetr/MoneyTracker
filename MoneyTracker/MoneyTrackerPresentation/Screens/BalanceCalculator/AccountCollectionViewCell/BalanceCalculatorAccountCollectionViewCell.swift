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
    
    private let _accountView = AccountView(appearance: CompositeAppearance(fonts: DefaultAppearanceFonts(), colors: DarkAppearanceColors(), images: DefaultAppearanceImages()))
    var accountView: UIView { return _accountView }
    var nameLabel: UILabel { return _accountView.nameLabel }
    var balanceLabel: UILabel { return _accountView.balanceLabel }
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(_accountView)
        setupContainerView()
    }
    
    private func setupContainerView() {
        _accountView.layer.shadowColor = UIColor.black.withAlphaComponent(0.35).cgColor
        _accountView.layer.shadowOpacity = 1
        _accountView.layer.shadowRadius = 6
        _accountView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layoutAccountView()
    }
    
    private func layoutAccountView() {
        let x: CGFloat = 0
        let y: CGFloat = 0
        let width = bounds.width
        let height = bounds.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        _accountView.frame = frame
        _accountView.layer.cornerRadius = 10
    }
    
    override var isHighlighted: Bool {
        willSet {
            setNeedsLayout()
            layoutIfNeeded()
            if newValue {
                _accountView.alpha = 0.6
            } else {
                _accountView.alpha = 1
            }
        }
    }
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        _accountView.changeAppearance(appearance)
    }
        
}
}

private class AccountView: AppearanceView {
    
    // MARK: Subviews
    
    let nameLabel = UILabel()
    let balanceLabel = UILabel()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        addSubview(nameLabel)
        setupNameLabel()
        addSubview(balanceLabel)
        setupBalanceLabel()
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = appearance.colors.cardPrimaryText
    }
    
    private func setupBalanceLabel() {
        balanceLabel.textColor = appearance.colors.cardPrimaryText
    }
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        nameLabel.textColor = appearance.colors.cardPrimaryText
        balanceLabel.textColor = appearance.colors.cardPrimaryText
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    
}
