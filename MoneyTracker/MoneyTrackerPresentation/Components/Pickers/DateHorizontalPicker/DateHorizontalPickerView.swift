//
//  DateHorizontalPickerView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 02.05.2022.
//

import Foundation
import UIKit
import PinLayout

class DateHorizontalPickerView: AppearanceView {
    
    // MARK: - Subviews
    
    let collectionView: UICollectionView
    private let collectionViewLayout: UICollectionViewFlowLayout
    
    // MARK: - Life cycle
    
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
    }
    
    private func setupCollectionView() {
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 5
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: dateCellIdentifier)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCollectionView()
    }
    
    private func layoutCollectionView() {
        collectionView.pin
            .left()
            .right()
            .top()
            .bottom()
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        findDateCells().forEach { $0.setAppearance(appearance) }
    }
    
    // MARK: - Create date cell
    
    private let dateCellIdentifier = "dateCellIdentifier"
    
    func createDateCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateCellIdentifier, for: indexPath)
        (cell as? AppearanceCollectionViewCell)?.setAppearance(appearance)
        return cell
    }
    
    func getDateCellSize() -> CGSize {
        return CGSize(width: 49, height: collectionView.frame.height)
    }
    
    private func findDateCells() -> [DateCell] {
        return collectionView.visibleCells.compactMap { $0 as? DateCell }
    }
}
