//
//  CategoryHorizontalPickerView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 13.03.2022.
//

import UIKit
import AUIKit

class CategoryHorizontalPickerView: AppearanceView {
    
    // MARK: - Subviews
    
    private let collectionViewLayout: UICollectionViewFlowLayout
    let collectionView: UICollectionView
    
    // MARK: - Intializer
    
    init(appearance: Appearance) {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(appearance: appearance)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(collectionView)
        setupCollectionView()
        setupCategoryCollectionViewCell()
        setupAddCategoryCollectionViewCell()
        changeAppearance(appearance)
    }
    
    private func setupCollectionView() {
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private var appearanceCollectionViewCell: [AppearanceCollectionViewCell] {
        return collectionView.visibleCells.compactMap { $0 as? AppearanceCollectionViewCell }
    }
    private let categoryCollectionViewCellReuseIdentifier = "categoryCollectionViewCellReuseIdentifier"
    private func setupCategoryCollectionViewCell() {
        collectionView.register(CategoryHorizontalPickerItemCell.self, forCellWithReuseIdentifier: categoryCollectionViewCellReuseIdentifier)
    }
    
    private let addCollectionViewCellReuseIdentifier = "addCollectionViewCellReuseIdentifier"
    private func setupAddCategoryCollectionViewCell() {
        collectionView.register(CategoryHorizontalPickerController.AddCollectionViewCell.self, forCellWithReuseIdentifier: addCollectionViewCellReuseIdentifier)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCollectionView()
    }
    
    private func layoutCollectionView() {
        collectionView.pin.all()
        collectionViewLayout.minimumLineSpacing = 8
        if let deferredScrollToItemClosure = deferredScrollToItemClosure {
            deferredScrollToItemClosure()
            self.deferredScrollToItemClosure = nil
        }
    }
    
    // MARK: - CategoryCollectionViewCell
    
    func categoryCollectionViewCell(indexPath: IndexPath, category: Category, isSelected: Bool) -> CategoryHorizontalPickerItemCell {
        let categoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCollectionViewCellReuseIdentifier, for: indexPath) as! CategoryHorizontalPickerItemCell
        categoryCollectionViewCell.setAppearance(appearance)
        categoryCollectionViewCell.titleLabel.text = category.name
        return categoryCollectionViewCell
    }
    
    func categoryCollectionViewCellSize() -> CGSize {
        let minCellWidth: CGFloat = 1
        return CGSize(width: minCellWidth, height: collectionView.frame.height)
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
    
    // MARK: Actions
    
    private var deferredScrollToItemClosure: (() -> ())?
    func collectionViewScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        if frame == .zero {
            deferredScrollToItemClosure = { [weak self] in
                guard let self = self else { return }
                self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
            }
        }
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        collectionView.backgroundColor = appearance.primaryBackground
        appearanceCollectionViewCell.forEach { $0.setAppearance(appearance) }
    }
    
}
