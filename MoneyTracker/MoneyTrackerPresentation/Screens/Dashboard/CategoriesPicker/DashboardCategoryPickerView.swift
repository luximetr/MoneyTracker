//
//  DashboardCategoriesPicker.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 02.04.2022.
//

import UIKit
import AUIKit

extension DashboardScreenViewController {
final class CategoryPickerView: AppearanceView {
    
    // MARK: - Subviews
    
    let titleLabel = UILabel()
    let addExpenseButton: TextButton
    private let collectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout()
    let collectionView: UICollectionView
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.addExpenseButton = TextButton(appearance: appearance)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        super.init(appearance: appearance)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(addExpenseButton)
        addSubview(collectionView)
        setupCollectionView()
        setupCategoryCollectionViewCell()
        setAppearance(appearance)
    }
    
    private func setupTitleLabel() {
        titleLabel.font = appearance.fonts.primary(size: 18, weight: .regular)
    }
        
    private let addCollectionViewCellReuseIdentifier = "addCollectionViewCellReuseIdentifier"
    private func setupCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryHorizontalPickerController.AddCollectionViewCell.self, forCellWithReuseIdentifier: addCollectionViewCellReuseIdentifier)
    }
    
    private let categoryCollectionViewCellReuseIdentifier = "categoryCollectionViewCellReuseIdentifier"
    private func setupCategoryCollectionViewCell() {
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCollectionViewCellReuseIdentifier)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
        layoutAddExpenseButton()
        layoutCollectionView()
    }
    
    private func layoutTitleLabel() {
        let x: CGFloat = 22
        let y: CGFloat = 0
        let sizeThatFits = titleLabel.sizeThatFits(CGSize(width: (bounds.width - x) * 0.5, height: bounds.height))
        let width = sizeThatFits.width
        let height = sizeThatFits.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        titleLabel.frame = frame
    }
    
    private func layoutAddExpenseButton() {
        let y: CGFloat = 0
        let sizeThatFits = addExpenseButton.sizeThatFits(CGSize(width: (bounds.width - 22) * 0.5, height: titleLabel.frame.size.height))
        let width = sizeThatFits.width
        let x = bounds.width - 22 - width
        let height = titleLabel.frame.size.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        addExpenseButton.frame = frame
    }
    
    private func layoutCollectionView() {
        let x: CGFloat = 0
        let y: CGFloat = titleLabel.frame.origin.y + titleLabel.frame.size.height + 10
        let width = bounds.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        collectionView.frame = frame
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 22, bottom: 5, right: 22)
        collectionViewFlowLayout.minimumInteritemSpacing = 3
        collectionViewFlowLayout.minimumLineSpacing = 3
    }
    
    // MARK: - CategoryCollectionViewCell
    
    func categoryCollectionViewCell(indexPath: IndexPath) -> CategoryCell {
        let categoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCollectionViewCellReuseIdentifier, for: indexPath) as! CategoryCell
        categoryCollectionViewCell.setAppearance(appearance)
        return categoryCollectionViewCell
    }
    
    func categoryCollectionViewCellSize(name: String) -> CGSize {
        let size = CategoryHorizontalPickerItemCell.sizeThatFits(collectionView.bounds.size, name: name)
        return size
    }
    
    // MARK: - AddCollectionViewCell
    
    func addCollectionViewCell(indexPath: IndexPath) -> CategoryHorizontalPickerController.AddCollectionViewCell {
        let addCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: addCollectionViewCellReuseIdentifier, for: indexPath) as! CategoryHorizontalPickerController.AddCollectionViewCell
        addCollectionViewCell.setAppearance(appearance)
        return addCollectionViewCell
    }
    
    func addCollectionViewCellSize(_ text: String) -> CGSize {
        let size = CategoryHorizontalPickerController.AddCollectionViewCell.sizeThatFits(collectionView.bounds.size, text: text)
        return size
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        titleLabel.textColor = appearance.colors.primaryText
        addExpenseButton.setTitleColor(appearance.colors.accent, for: .normal)
        collectionView.backgroundColor = appearance.colors.primaryBackground
    }
    
}
}
