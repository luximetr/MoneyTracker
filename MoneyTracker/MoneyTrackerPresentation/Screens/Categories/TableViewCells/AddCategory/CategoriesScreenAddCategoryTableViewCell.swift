//
//  CategoriesScreenAddCategoryTableViewCell.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 31.01.2022.
//

import UIKit
import AUIKit

final class CategoriesScreenAddCategoryTableViewCellController: AUIClosuresTableViewCellController {

}

final class CategoriesScreenAddCategoryTableViewCell: AUITableViewCell {
    
    // MARK: Subviews
    
    let pictureImageView = UIImageView()
    let _textLabel = UILabel()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(pictureImageView)
        setupPictureImageView()
        contentView.addSubview(_textLabel)
        setupTextLabel()
    }
    
    private func setupPictureImageView() {
        pictureImageView.contentMode = .scaleAspectFit
    }
    
    private func setupTextLabel() {
        _textLabel.textColor = Colors.blue
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutPictureImageView()
        layoutTextLabel()
    }
    
    private func layoutPictureImageView() {
        let x: CGFloat = 20
        let y: CGFloat = 16
        let width: CGFloat = 44
        let height: CGFloat = 44
        let frame = CGRect(x: x, y: y, width: width, height: height)
        pictureImageView.frame = frame
    }
    
    private func layoutTextLabel() {
        let x = pictureImageView.frame.origin.x + pictureImageView.frame.size.height + 28
        let y: CGFloat = 12
        let width = bounds.width - x - 28 - 28
        let height = bounds.height - 2 * y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        _textLabel.frame = frame
    }
    
}
