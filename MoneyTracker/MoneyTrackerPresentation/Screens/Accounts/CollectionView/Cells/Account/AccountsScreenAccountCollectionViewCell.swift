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
    
    let containerView = UIView()
    
    let nameLabel = UILabel()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(containerView)
        setupContainerView()
        containerView.addSubview(nameLabel)
        setupNameLabel()
    }
    
    private func setupContainerView() {
        containerView.layer.shadowColor = Colors.black.withAlphaComponent(0.25).cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = Colors.black
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutContainerView()
        layoutNameLabel()
    }
    
    private func layoutContainerView() {
        let x: CGFloat = 16
        let y: CGFloat = 6
        let width = bounds.width - 2 * x
        let height = bounds.height - 2 * y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        containerView.frame = frame
        containerView.layer.cornerRadius = 10
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
}
