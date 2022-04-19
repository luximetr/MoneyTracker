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
    
    init(appearance: Appearance) {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(appearance: appearance)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        setupCollectionView()
        addSubview(collectionView)
        changeAppearance(appearance)
    }
    
    private func setupCollectionView() {
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 25
        collectionViewLayout.minimumLineSpacing = 25
        collectionView.register(IconCell.self, forCellWithReuseIdentifier: iconCellId)
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private var appearanceCollectionViewCells: [AppearanceCollectionViewCell] {
        return collectionView.visibleCells.compactMap { $0 as? AppearanceCollectionViewCell }
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
            .bottom(self.pin.safeArea.bottom)
    }
    
    // MARK: - Create cell
    
    private let iconCellId = "iconCellId"
    
    func createIconCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iconCellId, for: indexPath)
        let iconCell = cell as? IconCell
        iconCell?.setAppearance(appearance)
        return cell
    }
    
    func getIconCellSize() -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        navigationBarView.backgroundColor = appearance.primaryBackground
        collectionView.backgroundColor = appearance.primaryBackground
        appearanceCollectionViewCells.forEach { $0.setAppearance(appearance) }
    }
}
}
