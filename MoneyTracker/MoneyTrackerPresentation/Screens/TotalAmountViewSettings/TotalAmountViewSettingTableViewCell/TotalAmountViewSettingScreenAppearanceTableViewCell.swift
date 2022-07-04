//
//  AppearanceSettingTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.07.2022.
//

import UIKit
import AUIKit
import PinLayout

extension TotalAmountViewSettingsScreenViewController {
final class TotalAmountViewSettingTableViewCell: AppearanceTableViewCell {

    // MARK: - Subviews
    
    let nameLabel = UILabel()
    let exampleLabel = UILabel()
    private let separatorView = UIView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(exampleLabel)
        contentView.addSubview(separatorView)
    }
    
    private func setupNameLabel(appearance: Appearance) {
        nameLabel.font = appearance.fonts.primary(size: 17, weight: .regular)
        nameLabel.textColor = appearance.colors.primaryText
    }
    
    private func setupExampleLabel(appearance: Appearance) {
        exampleLabel.font = appearance.fonts.primary(size: 13, weight: .regular)
        exampleLabel.textColor = appearance.colors.secondaryText
    }
    
    private func setupSeparatorView(appearance: Appearance) {
        separatorView.backgroundColor = appearance.colors.secondaryBackground
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutNameLabel()
        layoutExampleLabel()
        layoutSeparatorView()
    }
    
    private func layoutNameLabel() {
        let x: CGFloat = 20
        let y: CGFloat = 13
        let width = bounds.width - 2 * x
        let height: CGFloat = 20
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nameLabel.frame = frame
    }
    
    private func layoutExampleLabel() {
        let x: CGFloat = 20
        let height: CGFloat = 16
        let y: CGFloat = 38
        let width = bounds.width - 2 * x
        let frame = CGRect(x: x, y: y, width: width, height: height)
        exampleLabel.frame = frame
    }
    
    private func layoutSeparatorView() {
        let x: CGFloat = 20
        let width = bounds.width - x
        let height: CGFloat = 1
        let y = bounds.height - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        separatorView.frame = frame
    }
    
    // MARK: - Highlighted
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            nameLabel.alpha = 0.6
            exampleLabel.alpha = 0.6
        } else {
            nameLabel.alpha = 1
            exampleLabel.alpha = 1
        }
    }
    
    func setIsSelected(_ selected: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                self.nameLabel.textColor = self.getCodeLabelColor(isSelected: selected)
            }
        } else {
            self.nameLabel.textColor = self.getCodeLabelColor(isSelected: selected)
        }
    }
    
    private func getCodeLabelColor(isSelected: Bool) -> UIColor {
        if isSelected {
            return appearance?.colors.accent ?? .clear
        } else {
            return appearance?.colors.primaryText ?? .clear
        }
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        setupNameLabel(appearance: appearance)
        setupExampleLabel(appearance: appearance)
        setupSeparatorView(appearance: appearance)
    }

}
}
