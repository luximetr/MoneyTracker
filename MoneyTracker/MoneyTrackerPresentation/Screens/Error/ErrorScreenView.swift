//
//  UnexpectedErrorDetailsScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 17.02.2022.
//

import UIKit
import AUIKit

extension ErrorScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: Subviews
    
    let shareButton = PictureButton()
    let textView = UITextView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.colors.primaryBackground
        navigationBarView.addSubview(shareButton)
        setupShareButton()
        insertSubview(textView, belowSubview: navigationBarView)
        setupTextView()
    }
    
    private func setupShareButton() {
        shareButton.setImage(UIImage(systemName: "rectangle.stack.badge.person.crop"), for: .normal)
    }
    
    private func setupTextView() {
        textView.isEditable = false
        textView.textColor = appearance.colors.primaryText
        textView.alwaysBounceVertical = true
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutShareButton()
        layoutTextView()
    }
    
    func layoutShareButton() {
        let width: CGFloat = 18
        let height: CGFloat = 24
        let x = navigationBarView.bounds.width - (12 + width)
        let y: CGFloat = 8
        let frame = CGRect(x: x, y: y, width: width, height: height)
        shareButton.frame = frame
    }
    
    override func layoutTitleLabel() {
        let x = backButton.frame.origin.x + backButton.frame.size.width + 8
        let y: CGFloat = 0
        let width: CGFloat = navigationBarView.frame.width - 2 * x
        let height: CGFloat = navigationBarView.frame.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        titleLabel.frame = frame
        titleLabel.textAlignment = .center
    }
    
    private func layoutTextView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let width = bounds.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        textView.frame = frame
        textView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
}
}
