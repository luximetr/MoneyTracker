//
//  MenuTabBarItem.swift
//  MelonBookPresentation
//
//  Created by Ihor Myroniuk on 25.11.2020.
//

import AUIKit

final class MenuScreenTabBarItem: AUIButton {
    
    // MARK: Settigns
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                pictureImageView.tintColor = Colors.accent
                textLabel.textColor = Colors.accent
            } else {
                pictureImageView.tintColor = Colors.black
                textLabel.textColor = Colors.black
            }
        }
    }
    
    // MARK: Subviews
    
    let pictureImageView = UIImageView()
    let textLabel = UILabel()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        addSubview(pictureImageView)
        setupPictureImageView()
        addSubview(textLabel)
        setupTitleLabel()
    }
    
    private func setupPictureImageView() {
        pictureImageView.contentMode = .scaleAspectFit
        pictureImageView.tintColor = Colors.black
    }
    
    private func setupTitleLabel() {
        textLabel.font = Fonts.default(size: 14)
        textLabel.textColor = Colors.black
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutPictureImageView()
        layoutTextLabel()
    }
    
    private func layoutPictureImageView() {
        let width = bounds.width * 0.2
        let height = width
        let x = (bounds.width - width) / 2
        let y = (bounds.height - height) / 2 - 4
        let frame = CGRect(x: x, y: y, width: width, height: height)
        pictureImageView.frame = frame
    }
    
    private func layoutTextLabel() {
        let width = bounds.width * 0.8
        let x = (bounds.width - width) / 2
        let y = pictureImageView.frame.origin.y + pictureImageView.bounds.height
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        textLabel.frame = frame
        textLabel.textAlignment = .center
    }
    
}
