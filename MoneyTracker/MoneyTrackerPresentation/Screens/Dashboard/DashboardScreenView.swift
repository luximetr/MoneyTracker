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
    
    // MARK: - UI elements
    
    let templatesHeaderLabel = UILabel()
    private let templatesCollectionLayout: UICollectionViewFlowLayout
    let templatesCollectionView: UICollectionView
    
    // MARK: - Life cycle
    
    init() {
        templatesCollectionLayout = UICollectionViewFlowLayout()
        templatesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: templatesCollectionLayout)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.primaryBackground
        setupTemplatesHeaderLabel()
        setupTemplatesCollectionView()
    }
    
    private func setupTemplatesHeaderLabel() {
        templatesHeaderLabel.font = Fonts.default(size: 24, weight: .regular)
        templatesHeaderLabel.textColor = Colors.primaryText
        templatesHeaderLabel.numberOfLines = 1
    }
    
    private func setupTemplatesCollectionView() {
        templatesCollectionView.backgroundColor = .green
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(templatesCollectionView)
        addSubview(templatesHeaderLabel)
        layoutTemplatesCollectionView()
        layoutTemplatesHeaderLabel()
    }
    
    private func layoutTemplatesCollectionView() {
        templatesCollectionView.pin
            .left(18)
            .right(18)
            .bottom(pin.safeArea).marginBottom(24)
            .height(140)
    }
    
    private func layoutTemplatesHeaderLabel() {
        templatesHeaderLabel.pin
            .left(to: templatesCollectionView.edge.left)
            .bottom(to: templatesCollectionView.edge.top).marginBottom(16)
            .sizeToFit()
    }
    
    // MARK: - Template cell
    
    func createTemplateCell(indexPath: IndexPath, template: ExpenseTemplate) -> DashboardTemplateCollectionCell {
        let cell = templatesCollectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath) as! DashboardTemplateCollectionCell
        cell.titleLabel.text = template.name
        return cell
    }
    
    func getTemplateCellSize() -> CGSize {
        return CGSize(width: 100, height: 40)
    }
}
