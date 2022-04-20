//
//  SelectAppearanceScreenAppearanceTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 20.04.2022.
//

import UIKit
import AUIKit
import PinLayout

extension SelectAppearanceScreenViewController {
final class AppearanceSettingTableViewCell: AppearanceTableViewCell {

    // MARK: - Subviews
    
    let nameLabel = UILabel()
    private let separatorView = UIView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(separatorView)
    }
    
    private func setupNameLabel(appearance: Appearance) {
        nameLabel.textColor = appearance.primaryText
    }
    
    private func setupSeparatorView(appearance: Appearance) {
        separatorView.backgroundColor = appearance.secondaryBackground
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutNameLabel()
        layoutSeparatorView()
    }
    
    private func layoutNameLabel() {
        let x: CGFloat = 20
        let y: CGFloat = 0
        let width = bounds.width - 2 * x
        let height = bounds.height - 1
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nameLabel.frame = frame
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
        } else {
            nameLabel.alpha = 1
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
            return appearance?.accent ?? .clear
        } else {
            return appearance?.primaryText ?? .clear
        }
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        setupNameLabel(appearance: appearance)
        setupSeparatorView(appearance: appearance)
    }

}
}
