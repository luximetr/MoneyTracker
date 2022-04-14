//
//  SelectLanguageLanguageTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.04.2022.
//

import UIKit
import AUIKit
import PinLayout

extension SelectLanguageScreenViewController {
final class LanguageTableViewCell: AUITableViewCell {

    // MARK: - Subviews
    
    let nameLabel = UILabel()
    let codeLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        setupNameLabel()
        contentView.addSubview(codeLabel)
        setupCodeLabel()
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = Colors.primaryText
    }
    
    private func setupCodeLabel() {
        codeLabel.textColor = Colors.primaryText
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCodeLabel()
        layoutNameLabel()
    }
    
    private func layoutNameLabel() {
        nameLabel.pin
            .vCenter()
            .left()
            .right(to: codeLabel.edge.left)
            .sizeToFit(.width)
            .marginLeft(28)
    }
    
    private func layoutCodeLabel() {
        codeLabel.pin
            .vCenter()
            .right(pin.safeArea)
            .sizeToFit()
            .marginRight(28)
    }
    
    // MARK: - Update
    
    func setIsSelected(_ selected: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                self.codeLabel.textColor = self.getCodeLabelColor(isSelected: selected)
            }
        } else {
            self.codeLabel.textColor = self.getCodeLabelColor(isSelected: selected)
        }
    }
    
    private func getCodeLabelColor(isSelected: Bool) -> UIColor {
        if isSelected {
            return Colors.accent
        } else {
            return Colors.primaryText
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            nameLabel.alpha = 0.6
            codeLabel.alpha = 0.6
        } else {
            nameLabel.alpha = 1
            codeLabel.alpha = 1
        }
    }

}
}
