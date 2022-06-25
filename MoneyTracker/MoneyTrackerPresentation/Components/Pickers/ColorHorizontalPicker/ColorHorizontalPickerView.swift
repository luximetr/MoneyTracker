//
//  ColorHorizontalPickerView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 03.04.2022.
//

import UIKit
import AUIKit
import PinLayout

final class ColorHorizontalPickerView: AppearanceView {
    
    // MARK: - Data
    
    var contentInset = UIEdgeInsets.zero {
        didSet { collectionView.contentInset = contentInset }
    }
    
    // MARK: - Subviews
    
    private let collectionViewLayout: UICollectionViewFlowLayout
    let collectionView: UICollectionView
    
    // MARK: - Life cycle
    
    override init(frame: CGRect = .zero, appearance: Appearance) {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(frame: frame, appearance: appearance)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(collectionView)
        setupCollectionView()
        setAppearance(appearance)
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
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        collectionView.backgroundColor = appearance.colors.primaryBackground
    }
    
    // MARK: - Color cell
    
    private let colorCellId = "colorCellId"
    
    func createColorCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorCellId, for: indexPath) as! ColorCell
        cell.setAppearance(appearance)
        return cell
    }
    
    func getColorCellSize() -> CGSize {
        return CGSize(width: 36, height: 36)
    }
}
