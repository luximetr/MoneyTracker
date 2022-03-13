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
        setupCollectionView()
    }
    
    // MARK: - Layout
    
    // MARK: - Collection view
    
    private let collectionViewLayout: UICollectionViewFlowLayout
    let collectionView: UICollectionView
    
    private func setupCollectionView() {
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryHorizontalPickerItemCell.self, forCellWithReuseIdentifier: itemCellIdentifier)
    }
    
    // MARK: - Item cell
    
    private let itemCellIdentifier = "itemCellIdentifier"
    
    
}
