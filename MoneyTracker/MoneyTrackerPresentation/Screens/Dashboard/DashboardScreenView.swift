//
//  DashboardScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.03.2022.
//

import UIKit
import AUIKit
import PinLayout

extension DashboardScreenViewController {
final class ScreenView: TitleNavigationBarScreenView {
    
    // MARK: - Initializer
        
    init(appearance: Appearance) {
        self.historyButton = PictureButton()
        self.categoryPickerView = CategoryPickerView(appearance: appearance)
        self.accountPickerView = AccountPickerView(appearance: appearance)
        self.templatesView = TemplatesView(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: Subviews
    
    let historyButton: PictureButton
    let categoryPickerView: CategoryPickerView
    let accountPickerView: AccountPickerView
    let templatesView: TemplatesView
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        navigationBarView.addSubview(historyButton)
        setupHistoryButton()
        addSubview(categoryPickerView)
        addSubview(accountPickerView)
        addSubview(templatesView)
        changeAppearance(appearance)
    }
    
    private func setupHistoryButton() {
        historyButton.setImage(Images.expensesHistory.withRenderingMode(.alwaysTemplate), for: .normal)
        historyButton.imageView?.tintColor = appearance.colors.primaryText
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutHistoryButton()
        layoutTemplatesView()
        layoutCategoryPickerView()
        layoutAccountPickerView()
    }
    
    private func layoutHistoryButton() {
        let width: CGFloat = 21
        let height: CGFloat = 18
        let x = navigationBarView.frame.size.width - 20 - width
        let y = (navigationBarView.frame.size.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        historyButton.frame = frame
    }
    
    private func layoutTemplatesView() {
        let x: CGFloat = 0
        let height = bounds.height - navigationBarView.frame.origin.y - navigationBarView.frame.size.height
        let sizeThatFits = templatesView.sizeThatFits(CGSize(width: bounds.width, height: height))
        let y: CGFloat = bounds.height - sizeThatFits.height + templatesViewY
        let width = bounds.width
        let frame = CGRect(x: x, y: y, width: width, height: height)
        templatesView.frame = frame
    }
    
    var templatesViewY: CGFloat = 0
    func moveAccountViewIfPossible(_ h: CGFloat) {
        var newTemplatesViewY = templatesViewY + h
        let height = bounds.height - navigationBarView.frame.origin.y - navigationBarView.frame.size.height
        let sizeThatFits = templatesView.sizeThatFits(CGSize(width: bounds.width, height: height))
        let y: CGFloat = bounds.height - sizeThatFits.height + newTemplatesViewY
        
        if y <= (navigationBarView.frame.origin.y + navigationBarView.frame.size.height) {
            newTemplatesViewY = sizeThatFits.height - bounds.height + navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        } else if y > (bounds.height - sizeThatFits.height) {
            newTemplatesViewY = 0
        }
        
        templatesViewY = newTemplatesViewY
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func finishMove(movingUp: Bool) {
        let height = bounds.height - navigationBarView.frame.origin.y - navigationBarView.frame.size.height
        let sizeThatFits = templatesView.sizeThatFits(CGSize(width: bounds.width, height: height))
        let tt = templatesView.bounds.height - sizeThatFits.height
        if movingUp {
            if templatesViewY <= -tt * 0.10 {
                templatesViewY = sizeThatFits.height - bounds.height + navigationBarView.frame.origin.y + navigationBarView.frame.size.height
            } else {
                templatesViewY = 0
            }
        } else {
            if templatesViewY <= -tt * 0.90 {
                templatesViewY = sizeThatFits.height - bounds.height + navigationBarView.frame.origin.y + navigationBarView.frame.size.height
            } else {
                templatesViewY = 0
            }
        }
        setNeedsLayout()
        UIView.animate(withDuration: 0.2, delay: 0, options: []) {
            self.layoutIfNeeded()
        } completion: { finished in
            
        }
    }
    
    private func layoutCategoryPickerView() {
        let templatePickerHeight = bounds.height - navigationBarView.frame.origin.y - navigationBarView.frame.size.height
        let templatePickerSizeThatFits = templatesView.sizeThatFits(CGSize(width: bounds.width, height: templatePickerHeight))
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let width = bounds.width
        let height = (bounds.height - y - templatePickerSizeThatFits.height) * 0.5
        let frame = CGRect(x: x, y: y, width: width, height: height)
        categoryPickerView.frame = frame
    }
    
    private func layoutAccountPickerView() {
        let templatePickerHeight = bounds.height - navigationBarView.frame.origin.y - navigationBarView.frame.size.height
        let templatePickerSizeThatFits = templatesView.sizeThatFits(CGSize(width: bounds.width, height: templatePickerHeight))
        let x: CGFloat = 0
        let y = categoryPickerView.frame.origin.y + categoryPickerView.frame.size.height
        let width = bounds.width
        let height = bounds.height - y - templatePickerSizeThatFits.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        accountPickerView.frame = frame
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        historyButton.imageView?.tintColor = appearance.colors.primaryText
        categoryPickerView.changeAppearance(appearance)
        accountPickerView.changeAppearance(appearance)
        templatesView.changeAppearance(appearance)
    }
    
}
}
