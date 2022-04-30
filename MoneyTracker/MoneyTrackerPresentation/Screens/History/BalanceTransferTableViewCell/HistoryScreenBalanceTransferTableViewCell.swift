//
//  BalanceTransferTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import UIKit
import AUIKit

extension HistoryScreenViewController {
final class BalanceTransferTableViewCell: AppearanceTableViewCell {
    
    // MARK: - Subviews
    
    let fromAccountLabel = UILabel()
    let fromAmountLabel = UILabel()
    let toAccountLabel = UILabel()
    let toAmountLabel = UILabel()
    let separatorView = UIView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(fromAccountLabel)
        setupFromAccountLabel()
        contentView.addSubview(fromAmountLabel)
        setupFromAmountLabel()
        contentView.addSubview(toAccountLabel)
        setupToAccountLabel()
        contentView.addSubview(toAmountLabel)
        setupToAmountLabel()
        contentView.addSubview(separatorView)
    }
    
    private func setupFromAccountLabel() {
        fromAccountLabel.font = Fonts.default(size: 12, weight: .regular)
    }
    
    private func setupToAccountLabel() {
        toAccountLabel.font = Fonts.default(size: 12, weight: .regular)
    }
    
    private func setupFromAmountLabel() {
        fromAmountLabel.font = Fonts.default(size: 12, weight: .semibold)
    }
    
    private func setupToAmountLabel() {
        toAmountLabel.font = Fonts.default(size: 12, weight: .semibold)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutFromAccountLabel()
        layoutToAccountLabel()
        layoutFromAmountLabel()
        layoutToAmountLabel()
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
    
    private func layoutToAccountLabel() {
        let x: CGFloat = 16
        let y: CGFloat = fromAccountLabel.frame.origin.y + fromAccountLabel.frame.size.height
        let height: CGFloat = 20
        let width = toAccountLabel.sizeThatFits(CGSize(width: bounds.width, height: height)).width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        toAccountLabel.frame = frame
    }
    
    private func layoutFromAmountLabel() {
        let x: CGFloat = fromAccountLabel.frame.origin.x + fromAccountLabel.frame.size.width + 16
        let y: CGFloat = 6
        let height: CGFloat = 20
        let width = bounds.width - x - 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        fromAmountLabel.frame = frame
        fromAmountLabel.textAlignment = .right
    }
    
    private func layoutToAmountLabel() {
        let x: CGFloat = toAccountLabel.frame.origin.x + toAccountLabel.frame.size.width + 16
        let y: CGFloat = fromAmountLabel.frame.origin.y + fromAmountLabel.frame.size.height
        let height: CGFloat = 20
        let width = bounds.width - x - 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        toAmountLabel.frame = frame
        toAmountLabel.textAlignment = .right
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
        backgroundColor = appearance.primaryBackground
        fromAccountLabel.textColor = appearance.secondaryText
        toAccountLabel.textColor = appearance.primaryText
        fromAmountLabel.textColor = appearance.dangerousActionBackground
        toAmountLabel.textColor = appearance.successText
        separatorView.backgroundColor = appearance.secondaryBackground
    }
    
}
}
