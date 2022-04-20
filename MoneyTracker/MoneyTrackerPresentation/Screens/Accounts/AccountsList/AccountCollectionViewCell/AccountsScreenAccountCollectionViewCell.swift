//
//  AccountsScreenAccountCollectionViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 08.02.2022.
//

import UIKit
import AUIKit

extension AccountsScreenViewController {
final class AccountCollectionViewCell: AUICollectionViewCell {
    
    // MARK: Subviews
    
    private let _accountView = AccountView()
    var accountView: UIView { return _accountView }
    var nameLabel: UILabel { return _accountView.nameLabel }
    var balanceLabel: UILabel { return _accountView.balanceLabel }
    let deleteButton = TextFilledButton()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(deleteButton)
        setupDeleteButton()
        contentView.addSubview(_accountView)
        setupContainerView()
    }
    
    private func setupDeleteButton() {
        deleteButton.backgroundColor = Colors.dangerousActionBackground
//        deleteButton.layer.shadowColor = Colors.black.withAlphaComponent(0.85).cgColor
//        deleteButton.layer.shadowOpacity = 1
//        deleteButton.layer.shadowRadius = 6
//        deleteButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private func setupContainerView() {
        _accountView.layer.shadowColor = Colors.black.withAlphaComponent(0.35).cgColor
        _accountView.layer.shadowOpacity = 1
        _accountView.layer.shadowRadius = 6
        _accountView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layoutDeleteButton()
        layoutAccountView()
    }
    
    private func layoutDeleteButton() {
        let y: CGFloat = 0
        let width: CGFloat = bounds.width * 0.25
        let x: CGFloat = bounds.width - width
        let height = bounds.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        deleteButton.frame = frame
        deleteButton.layer.cornerRadius = 10
    }
    
    var accountViewX: CGFloat = 0
    func moveAccountViewIfPossible(_ h: CGFloat) {
        var r = accountViewX + h
        if r > 0 {
            r = 0
        }
        if r < -deleteButton.bounds.width {
            r = -deleteButton.bounds.width
        }
        if r <= 0, r >= -deleteButton.bounds.width {
            accountViewX = r
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    func finishMove() {
        if accountViewX > -(deleteButton.bounds.width / 2) {
            accountViewX = 0
        } else {
            accountViewX = -deleteButton.bounds.width
        }
        setNeedsLayout()
        UIView.animate(withDuration: 0.2, delay: 0, options: []) {
            self.layoutIfNeeded()
        } completion: { finished in
            
        }
    }
    
    private func layoutAccountView() {
        let x = accountViewX
        let y: CGFloat = 0
        let width = bounds.width
        let height = bounds.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        _accountView.frame = frame
        _accountView.layer.cornerRadius = 10
    }
    
    override var isHighlighted: Bool {
        willSet {
            accountViewX = 0
            setNeedsLayout()
            layoutIfNeeded()
            if newValue {
                _accountView.alpha = 0.6
                deleteButton.alpha = 0
            } else {
                _accountView.alpha = 1
                deleteButton.alpha = 1
            }
        }
    }
        
}
}

private class AccountView: AUIView {
    
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
        nameLabel.textColor = Colors.white
    }
    
    private func setupBalanceLabel() {
        balanceLabel.textColor = Colors.white
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
