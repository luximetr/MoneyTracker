//
//  AccountsScreenAccountCollectionViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 08.02.2022.
//

import UIKit
import AUIKit

extension AccountsScreenView {
final class AccountCollectionViewCell: AUICollectionViewCell {
    
    // MARK: Subviews
    
    private let _accountView = AccountView()
    var accountView: UIView { return _accountView }
    var nameLabel: UILabel { return _accountView.nameLabel }
    var balanceLabel: UILabel { return _accountView.balanceLabel }
    let deleteView = UIButton()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(deleteView)
        setupDeleteView()
        contentView.addSubview(_accountView)
        setupContainerView()
    }
    
    private func setupDeleteView() {
        deleteView.backgroundColor = Colors.dangerousActionBackground
        deleteView.layer.shadowColor = Colors.black.withAlphaComponent(0.25).cgColor
        deleteView.layer.shadowOpacity = 1
        deleteView.layer.shadowRadius = 6
        deleteView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private func setupContainerView() {
        _accountView.layer.shadowColor = Colors.black.withAlphaComponent(0.25).cgColor
        _accountView.layer.shadowOpacity = 1
        _accountView.layer.shadowRadius = 6
        _accountView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutDeleteView()
        layoutContainerView()
    }
    
    private func layoutDeleteView() {
        let y: CGFloat = 0
        let width: CGFloat = 76
        let x: CGFloat = bounds.width - width
        let height = bounds.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        deleteView.frame = frame
        deleteView.layer.cornerRadius = 10
    }
    
    var xOffset: CGFloat = 0 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    private func layoutContainerView() {
        let x: CGFloat = xOffset
        let y: CGFloat = 0
        let width = bounds.width
        let height = bounds.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        _accountView.frame = frame
        _accountView.layer.cornerRadius = 10
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
        nameLabel.textColor = Colors.black
    }
    
    private func setupBalanceLabel() {
        balanceLabel.textColor = Colors.black
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBalanceLabel()
        layoutNameLabel()
    }
    
    private func layoutBalanceLabel() {
        let x: CGFloat = 28
        let y: CGFloat = 12
        let width = bounds.width - x - 40
        let height = bounds.height - 2 * y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        balanceLabel.frame = frame
    }
    
    private func layoutNameLabel() {
        let x: CGFloat = 28
        let y: CGFloat = 12
        let width = bounds.width - x - 40
        let height = bounds.height - 2 * y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nameLabel.frame = frame
    }
    
}
