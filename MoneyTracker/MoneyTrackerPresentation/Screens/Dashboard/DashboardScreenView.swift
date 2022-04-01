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
    
    // MARK: Subviews
    
    var templatesCollectionView: UICollectionView {
        return templatesView.collectionView
    }
    let addExpenseButton = TextFilledButton()
    let templatesHeaderLabel = UILabel()
    let templatesView = TemplatesView()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.primaryBackground
        addSubview(addExpenseButton)
        setupAddExpenseButton()
        setupTemplatesHeaderLabel()
        addSubview(templatesHeaderLabel)
        setupTemplatesCollectionView()
        addSubview(templatesView)
    }
    
    private func setupAddExpenseButton() {
        addExpenseButton.backgroundColor = Colors.secondaryBackground
        addExpenseButton.setTitleColor(Colors.primaryText, for: .normal)
    }
    
    private func setupTemplatesHeaderLabel() {
        templatesHeaderLabel.font = Fonts.default(size: 24, weight: .regular)
        templatesHeaderLabel.textColor = Colors.primaryText
        templatesHeaderLabel.numberOfLines = 1
    }
    
    private let templateCellId = "templateCellId"
    private func setupTemplatesCollectionView() {
        templatesCollectionView.register(TemplateCollectionCell.self, forCellWithReuseIdentifier: templateCellId)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        layoutTemplatesHeaderLabel()
//        layoutAddExpenseButton()
        layoutTemplatesView()
    }
    
    private func layoutAddExpenseButton() {
        addExpenseButton.pin
            .left(24)
            .right(24)
            .bottom(to: templatesHeaderLabel.edge.top).marginBottom(24)
            .height(44)
    }
    
    private func layoutTemplatesHeaderLabel() {
        templatesHeaderLabel.pin
            .left(to: templatesCollectionView.edge.left)
            .bottom(to: templatesCollectionView.edge.top).marginBottom(16)
            .sizeToFit()
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
    
    func finishMove() {
        let height = bounds.height - navigationBarView.frame.origin.y - navigationBarView.frame.size.height
        let sizeThatFits = templatesView.sizeThatFits(CGSize(width: bounds.width, height: height))
        let tt = templatesView.bounds.height - sizeThatFits.height
        if templatesViewY <= -tt * 0.5 {
            templatesViewY = sizeThatFits.height - bounds.height + navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        } else {
            templatesViewY = 0
        }
        setNeedsLayout()
        UIView.animate(withDuration: 0.2, delay: 0, options: []) {
            self.layoutIfNeeded()
        } completion: { finished in
            
        }
    }
    
    // MARK: Template cell
    
    func createTemplateCell(indexPath: IndexPath, template: ExpenseTemplate) -> TemplateCollectionCell {
        let cell = templatesCollectionView.dequeueReusableCell(withReuseIdentifier: templateCellId, for: indexPath) as! TemplateCollectionCell
        cell.titleLabel.text = template.name
        return cell
    }
    
    func getTemplateCellSize() -> CGSize {
        let availableRowWidth = (bounds.width - 22 * 2 - 16) * 0.5
        return CGSize(width: availableRowWidth, height: 44)
    }
    
}
}
