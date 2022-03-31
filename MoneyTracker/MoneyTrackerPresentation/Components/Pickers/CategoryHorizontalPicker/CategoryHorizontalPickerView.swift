//
//  CategoryHorizontalPickerView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 13.03.2022.
//

import UIKit
import AUIKit

class CategoryHorizontalPickerView: AUIView {
    
    // MARK: - Life cycle
    
    override init(frame: CGRect = .zero) {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(frame: frame)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(collectionView)
        setupCollectionView()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCollectionView()
    }
    
    // MARK: - Collection view
    
    private let collectionViewLayout: UICollectionViewFlowLayout
    let collectionView: UICollectionView
    
    private let addCollectionViewCellReuseIdentifier = "addCollectionViewCellReuseIdentifier"
    private func setupCollectionView() {
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryHorizontalPickerItemCell.self, forCellWithReuseIdentifier: itemCellIdentifier)
        collectionView.register(CategoryHorizontalPickerController.AddCollectionViewCell.self, forCellWithReuseIdentifier: addCollectionViewCellReuseIdentifier)
    }
    
    private func layoutCollectionView() {
        collectionView.pin.all()
        collectionViewLayout.minimumLineSpacing = 8
    }
    
    // MARK: - Item cell
    
    private let itemCellIdentifier = "itemCellIdentifier"
    
    func createItemCell(indexPath: IndexPath, category: Category, isSelected: Bool) -> CategoryHorizontalPickerItemCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellIdentifier, for: indexPath) as! CategoryHorizontalPickerItemCell
        cell.titleLabel.text = category.name
        cell.update(isSelected: isSelected)
        return cell
    }
    
    func getItemCellSize() -> CGSize {
        let minCellWidth: CGFloat = 1
        return CGSize(width: minCellWidth, height: collectionView.frame.height)
    }
    
    // MARK: AddCollectionViewCell
    
    func createAddCollectionViewCell(indexPath: IndexPath) -> CategoryHorizontalPickerController.AddCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addCollectionViewCellReuseIdentifier, for: indexPath) as! CategoryHorizontalPickerController.AddCollectionViewCell
        return cell
    }
    
    func addCollectionViewCellSize(_ text: String) -> CGSize {
        let size = CategoryHorizontalPickerController.AddCollectionViewCell.sizeThatFits(collectionView.bounds.size, text: text)
        return size
    }
}
