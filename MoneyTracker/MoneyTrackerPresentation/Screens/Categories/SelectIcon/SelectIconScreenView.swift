//
//  SelectIconScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 02.04.2022.
//

import AUIKit
import PinLayout

extension SelectIconScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Subviews
    
    private let collectionViewLayout: UICollectionViewFlowLayout
    let collectionView: UICollectionView
    
    // MARK: - Life cycle
    
    init() {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        setupCollectionView()
        addSubview(collectionView)
        backgroundColor = Colors.primaryBackground
    }
    
    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = Colors.primaryBackground
    }
    
    private func setupCollectionView() {
        collectionView.register(IconCell.self, forCellWithReuseIdentifier: iconCellId)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCollectionView()
    }
    
    private func layoutCollectionView() {
        collectionView.pin
            .top(to: navigationBarView.edge.bottom)
            .left()
            .right()
            .bottom()
    }
    
    // MARK: - Create cell
    
    private let iconCellId = "iconCellId"
    
    func createIconCell(indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: iconCellId, for: indexPath)
    }
    
    func getIconCellSize() -> CGSize {
        return CGSize(width: 40, height: 40)
    }
}
}
