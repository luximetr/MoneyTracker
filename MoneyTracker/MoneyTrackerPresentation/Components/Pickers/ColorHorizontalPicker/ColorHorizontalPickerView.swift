//
//  ColorHorizontalPickerView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.04.2022.
//

import UIKit
import AUIKit
import PinLayout

final class ColorHorizontalPickerView: AUIView {
    
    // MARK: - Data
    
    var contentInset = UIEdgeInsets.zero {
        didSet { collectionView.contentInset = contentInset }
    }
    
    // MARK: - Subviews
    
    private let collectionViewLayout: UICollectionViewFlowLayout
    let collectionView: UICollectionView
    
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
    
    private func setupCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 16
        collectionView.contentInset = contentInset
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: colorCellId)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCollectionView()
    }
    
    private func layoutCollectionView() {
        collectionView.pin.all()
    }
    
    private let colorCellId = "colorCellId"
    
    func createColorCell(indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: colorCellId, for: indexPath)
    }
    
    func getColorCellSize() -> CGSize {
        return CGSize(width: 36, height: 36)
    }
}
