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
    
    let pickDayButton = UIButton()
    private let pickDayButtonBackground = UIView()
    private let pickDayButtonIcon = UIImageView()
    private let pickDayButtonGradientView = UIView()
    private let pickDayButtonGradientLayer = CAGradientLayer()
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
        addSubview(pickDayButtonBackground)
        addSubview(pickDayButtonGradientView)
        setupPickDayButtonGradientView()
        addSubview(pickDayButtonIcon)
        setupPickDayButtonIcon()
        addSubview(pickDayButton)
    }
    
    private func setupCollectionView() {
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 5
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.semanticContentAttribute = .forceRightToLeft
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: dateCellIdentifier)
    }
    
    private func setupPickDayButtonIcon() {
        pickDayButtonIcon.contentMode = .scaleAspectFit
        pickDayButtonIcon.image = Images.calendar
    }
    
    private func setupPickDayButtonGradientView() {
        pickDayButtonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        pickDayButtonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        pickDayButtonGradientView.layer.insertSublayer(pickDayButtonGradientLayer, at: 0)
        pickDayButtonGradientView.isUserInteractionEnabled = false
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCollectionView()
        layoutPickDayButtonIcon()
        layoutPickDayButton()
        layoutPickDayButtonBackground()
        layoutPickDayButtonGradientView()
    }
    
    private func layoutCollectionView() {
        collectionView.pin
            .left()
            .right()
            .top()
            .bottom()
    }
    
    private func layoutPickDayButtonIcon() {
        pickDayButtonIcon.pin
            .left(8)
            .vCenter()
            .width(15)
            .height(15)
    }
    
    private func layoutPickDayButton() {
        pickDayButton.pin
            .left()
            .top()
            .bottom()
            .width(31)
    }
    
    private func layoutPickDayButtonBackground() {
        pickDayButtonBackground.pin
            .left()
            .top()
            .bottom()
            .right(to: pickDayButton.edge.right)
    }
    
    private func layoutPickDayButtonGradientView() {
        pickDayButtonGradientView.pin
            .top()
            .bottom()
            .left(to: pickDayButtonBackground.edge.right)
            .width(40)
        pickDayButtonGradientLayer.frame = pickDayButtonGradientView.bounds
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        pickDayButtonBackground.backgroundColor = appearance.primaryBackground
        pickDayButtonIcon.tintColor = appearance.primaryText
        pickDayButtonGradientLayer.colors = [appearance.primaryBackground.withAlphaComponent(1).cgColor, appearance.primaryBackground.withAlphaComponent(0).cgColor]
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
