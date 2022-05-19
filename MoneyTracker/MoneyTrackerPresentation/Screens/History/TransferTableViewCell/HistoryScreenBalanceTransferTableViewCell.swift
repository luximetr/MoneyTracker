//
//  BalanceTransferTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import UIKit
import AUIKit

extension HistoryScreenViewController {
final class TransferTableViewCell: AppearanceTableViewCell {
    
    // MARK: - Subviews
    
    let fromAccountLabel = UILabel()
    let fromAmountLabel = UILabel()
    let balanceTransferImageView = UIImageView()
    let toAccountLabel = UILabel()
    let commentLabel = UILabel()
    let separatorView = UIView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(fromAccountLabel)
        contentView.addSubview(fromAmountLabel)
        contentView.addSubview(balanceTransferImageView)
        setupBalanceTransferImageView()
        contentView.addSubview(toAccountLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(separatorView)
    }
    
    private func setupBalanceTransferImageView() {
        balanceTransferImageView.contentMode = .scaleAspectFit
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutFromAccountLabel()
        layoutFromAmountLabel()
        layoutBalanceTransferImageView()
        layoutToAccountLabel()
        layoutCommentLabel()
        layoutSeparatorView()
    }
    
    private func layoutFromAccountLabel() {
        let x: CGFloat = 16
        let y: CGFloat = 6
        let height: CGFloat = 20
        let width = fromAccountLabel.sizeThatFits(CGSize(width: bounds.width, height: height)).width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        fromAccountLabel.frame = frame
    }
    
    private func layoutFromAmountLabel() {
        let x: CGFloat = fromAccountLabel.frame.maxX + 16
        let y: CGFloat = 6
        let height: CGFloat = 20
        let width = bounds.width - x - 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        fromAmountLabel.frame = frame
        fromAmountLabel.textAlignment = .right
    }
    
    private func layoutBalanceTransferImageView() {
        let x: CGFloat = 16
        let y: CGFloat = fromAccountLabel.frame.maxY + 4
        let height: CGFloat = 12
        let width: CGFloat = 12
        let frame = CGRect(x: x, y: y, width: width, height: height)
        balanceTransferImageView.frame = frame
    }
    
    private func layoutToAccountLabel() {
        let x: CGFloat = balanceTransferImageView.frame.maxX + 4
        let y: CGFloat = fromAccountLabel.frame.maxY
        let height: CGFloat = 20
        let width = toAccountLabel.sizeThatFits(CGSize(width: bounds.width, height: height)).width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        toAccountLabel.frame = frame
    }
    
    private func layoutCommentLabel() {
        let x: CGFloat = toAccountLabel.frame.maxX + 16
        let y: CGFloat = fromAmountLabel.frame.maxY
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
        fromAccountLabel.textColor = appearance.colors.secondaryText
        fromAccountLabel.font = appearance.fonts.primary(size: 12, weight: .regular)
        fromAmountLabel.textColor = appearance.colors.primaryText
        toAccountLabel.font = appearance.fonts.primary(size: 12, weight: .regular)
        toAccountLabel.textColor = appearance.colors.primaryText
        fromAmountLabel.font = appearance.fonts.primary(size: 12, weight: .semibold)
        balanceTransferImageView.tintColor = appearance.colors.primaryText
        balanceTransferImageView.image = appearance.images.cycle.withRenderingMode(.alwaysTemplate)
        commentLabel.textColor = appearance.colors.secondaryText
        commentLabel.font = appearance.fonts.primary(size: 12, weight: .regular)
        separatorView.backgroundColor = appearance.colors.secondaryBackground
    }
    
}
}
