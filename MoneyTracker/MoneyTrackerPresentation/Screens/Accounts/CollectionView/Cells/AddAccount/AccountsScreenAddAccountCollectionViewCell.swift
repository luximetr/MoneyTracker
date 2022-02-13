//
//  AccountsScreenAddAccountCollectionViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.02.2022.
//

import UIKit
import AUIKit

extension AccountsScreenView {
final class AddAccountCollectionViewCell: AUICollectionViewCell {
    
    // MARK: Subviews
    
    let pictureImageView = UIImageView()
    let textLabel = UILabel()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        contentView.addSubview(pictureImageView)
        setupPictureImageView()
        contentView.addSubview(textLabel)
        setupTextLabel()
    }
    
    private func setupPictureImageView() {
        pictureImageView.contentMode = .scaleAspectFit
        pictureImageView.image = Images.plusInDashCircle
    }
    
    private func setupTextLabel() {
        textLabel.textColor = Colors.accent
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutPictureImageView()
        layoutTextLabel()
    }
    
    private func layoutPictureImageView() {
        let x: CGFloat = 0
        let y: CGFloat = 0
        let width: CGFloat = 44
        let height: CGFloat = 44
        let frame = CGRect(x: x, y: y, width: width, height: height)
        pictureImageView.frame = frame
    }
    
    private func layoutTextLabel() {
        let x = pictureImageView.frame.origin.x + pictureImageView.frame.size.width + 12
        let y: CGFloat = 0
        let width = bounds.width - pictureImageView.bounds.size.width - 12
        let height = bounds.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        textLabel.frame = frame
    }
    
    override var isHighlighted: Bool {
        willSet {
            if newValue {
                pictureImageView.alpha = 0.6
                textLabel.alpha = 0.6
            } else {
                pictureImageView.alpha = 1
                textLabel.alpha = 1
            }
        }
    }

}
}
