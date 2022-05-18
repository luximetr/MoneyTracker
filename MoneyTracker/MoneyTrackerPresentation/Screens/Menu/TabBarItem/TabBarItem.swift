//
//  MenuTabBarItem.swift
//  MelonBookPresentation
//
//  Created by Ihor Myroniuk on 25.11.2020.
//

import AUIKit

extension MenuScreenViewController {
final class TabBarItem: AppearanceButton {
    
    // MARK: - Subviews
    
    let pictureImageView = UIImageView()
    let textLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(pictureImageView)
        setupPictureImageView()
        addSubview(textLabel)
        setupTitleLabel()
    }
    
    private func setupPictureImageView() {
        pictureImageView.contentMode = .scaleAspectFit
        pictureImageView.tintColor = appearance.colors.primaryText
    }
    
    private func setupTitleLabel() {
        textLabel.font = appearance.fonts.primary(size: 14, weight: .regular)
        textLabel.textColor = appearance.colors.primaryText
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.5
    }
    
    // MARK: - Layout
    
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
        let width = bounds.width
        let x = (bounds.width - width) / 2
        let y = pictureImageView.frame.origin.y + pictureImageView.bounds.height
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        textLabel.frame = frame
        textLabel.textAlignment = .center
    }
    
    // MARK: - Events
    
    private var _selected = false
    func setSelected(_ selected: Bool, animated: Bool) {
        self._selected = selected
        if selected {
            pictureImageView.tintColor = appearance.colors.accent
            textLabel.textColor = appearance.colors.accent
        } else {
            pictureImageView.tintColor = appearance.colors.primaryText
            textLabel.textColor = appearance.colors.primaryText
        }
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        pictureImageView.tintColor = appearance.colors.primaryText
        textLabel.textColor = appearance.colors.primaryText
        setSelected(_selected, animated: false)
    }
    
}
}
