//
//  DashboardScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.03.2022.
//

import UIKit
import AUIKit
import PinLayout

class DashboardScreenView: TitleNavigationBarScreenView {
    
    // MARK: - Life cycle
    
    init() {
        templatesCollectionLayout = UICollectionViewFlowLayout()
        templatesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: templatesCollectionLayout)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(addExpenseButton)
        addSubview(templatesCollectionView)
        addSubview(templatesHeaderLabel)
        backgroundColor = Colors.primaryBackground
        setupAddExpenseButton()
        setupTemplatesHeaderLabel()
        setupTemplatesCollectionView()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTemplatesCollectionView()
        layoutTemplatesHeaderLabel()
        layoutAddExpenseButton()
    }
    
    // MARK: - AddExpenseButton
    
    let addExpenseButton = UIButton()
    
    private func setupAddExpenseButton() {
        addExpenseButton.backgroundColor = Colors.secondaryBackground
        addExpenseButton.setTitleColor(Colors.primaryText, for: .normal)
        addExpenseButton.layer.cornerRadius = 10
    }
    
    private func layoutAddExpenseButton() {
        addExpenseButton.pin
            .left(24)
            .right(24)
            .bottom(to: templatesHeaderLabel.edge.top).marginBottom(24)
            .height(44)
    }
    
    // MARK: - TemplatesHeaderLabel
    
    let templatesHeaderLabel = UILabel()
    
    private func setupTemplatesHeaderLabel() {
        templatesHeaderLabel.font = Fonts.default(size: 24, weight: .regular)
        templatesHeaderLabel.textColor = Colors.primaryText
        templatesHeaderLabel.numberOfLines = 1
    }
    
    private func layoutTemplatesHeaderLabel() {
        templatesHeaderLabel.pin
            .left(to: templatesCollectionView.edge.left)
            .bottom(to: templatesCollectionView.edge.top).marginBottom(16)
            .sizeToFit()
    }
    
    // MARK: - TemplateCollectionView
    
    private let templatesCollectionLayout: UICollectionViewFlowLayout
    let templatesCollectionView: UICollectionView
    
    private func setupTemplatesCollectionView() {
        templatesCollectionView.register(DashboardTemplateCollectionCell.self, forCellWithReuseIdentifier: templateCellId)
    }
    
    private let templatesCollectionLeft: CGFloat = 24
    private let templatesCollectionRight: CGFloat = 24
    private let templatesCollectionItemsHorizontalSpace: CGFloat = 18
    private let templatesCollectionNumberOfItemsInRow: CGFloat = 2
    
    private func layoutTemplatesCollectionView() {
        templatesCollectionView.pin
            .left(templatesCollectionLeft)
            .right(templatesCollectionRight)
            .bottom(pin.safeArea).marginBottom(24)
            .height(140)
    }
    
    // MARK: - Template cell
    
    private let templateCellId = "templateCellId"
    
    func createTemplateCell(indexPath: IndexPath, template: ExpenseTemplate) -> DashboardTemplateCollectionCell {
        let cell = templatesCollectionView.dequeueReusableCell(withReuseIdentifier: templateCellId, for: indexPath) as! DashboardTemplateCollectionCell
        cell.titleLabel.text = template.name
        return cell
    }
    
    func getTemplateCellSize() -> CGSize {
        let availableRowWidth = templatesCollectionView.frame.width
        let totalHorizontalSpace = templatesCollectionItemsHorizontalSpace * (templatesCollectionNumberOfItemsInRow - 1)
        let cellWidth = (availableRowWidth - totalHorizontalSpace) / templatesCollectionNumberOfItemsInRow
        return CGSize(width: cellWidth, height: 40)
    }
}
