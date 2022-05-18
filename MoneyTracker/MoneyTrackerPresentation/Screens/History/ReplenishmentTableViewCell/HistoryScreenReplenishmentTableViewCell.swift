//
//  ReplenishmentTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import UIKit
import AUIKit

extension HistoryScreenViewController {
final class ReplenishmentTableViewCell: AppearanceTableViewCell {
    
    // MARK: - Subviews
    
    let accountLabel = UILabel()
    let amountLabel = UILabel()
    let commentLabel = UILabel()
    let separatorView = UIView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(accountLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(separatorView)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutAccountLabel()
        layoutAmountLabel()
        layoutCommentLabel()
        layoutSeparatorView()
    }
    
    private func layoutAccountLabel() {
        let x: CGFloat = 16
        let y: CGFloat = 8
        let height: CGFloat = bounds.height - y * 2 - 1
        let width = accountLabel.sizeThatFits(CGSize(width: bounds.width, height: height)).width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        accountLabel.frame = frame
    }
    
    private func layoutAmountLabel() {
        let x: CGFloat = accountLabel.frame.origin.x + accountLabel.frame.size.width + 16
        let y: CGFloat = 6
        let height: CGFloat = 20
        let width = bounds.width - x - 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        amountLabel.frame = frame
        amountLabel.textAlignment = .right
    }
    
    private func layoutCommentLabel() {
        let x: CGFloat = accountLabel.frame.origin.x + accountLabel.frame.size.width + 16
        let y: CGFloat = amountLabel.frame.origin.y + amountLabel.frame.size.height
        let height: CGFloat = 20
        let width = bounds.width - x - 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        commentLabel.frame = frame
        commentLabel.textAlignment = .right
    }
    
    private func layoutSeparatorView() {
        let x: CGFloat = 16
        let y: CGFloat = bounds.height - 1
        let height: CGFloat = 1
        let width = bounds.width - x
        let frame = CGRect(x: x, y: y, width: width, height: height)
        separatorView.frame = frame
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        accountLabel.textColor = appearance.colors.primaryText
        accountLabel.font = appearance.fonts.primary(size: 12, weight: .regular)
        amountLabel.textColor = appearance.successText
        amountLabel.font = appearance.fonts.primary(size: 12, weight: .semibold)
        commentLabel.textColor = appearance.colors.secondaryText
        commentLabel.font = appearance.fonts.primary(size: 12, weight: .regular)
        separatorView.backgroundColor = appearance.colors.secondaryBackground
    }
    
}
}
