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
    private let collectionFadeView = UIView()
    let datePicker = UIDatePicker()
    private let pickDayButtonBackground = PassthroughView()
    private let pickDayButtonIcon = UIImageView()
    private let pickDayButtonGradientView = UIView()
    private let pickDayButtonGradientLayer = CAGradientLayer()
    private let selectedDayFrameView = UIView()
    
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
        addSubview(collectionFadeView)
        setupCollectionFadeView()
        addSubview(datePicker)
        setupDatePicker()
        addSubview(pickDayButtonBackground)
        addSubview(pickDayButtonGradientView)
        setupPickDayButtonGradientView()
        addSubview(pickDayButtonIcon)
        setupPickDayButtonIcon()
        addSubview(selectedDayFrameView)
        setupSelectedDayFrameView()
        
    }
    
    private func setupCollectionView() {
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.semanticContentAttribute = .forceRightToLeft
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: dateCellIdentifier)
    }
    
    private func setupCollectionFadeView() {
        collectionFadeView.isUserInteractionEnabled = false
    }
    
    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
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
    
    private func setupSelectedDayFrameView() {
        selectedDayFrameView.isUserInteractionEnabled = false
        selectedDayFrameView.layer.borderWidth = 1
        selectedDayFrameView.layer.cornerRadius = 5
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCollectionView()
        layoutPickDayButtonIcon()
        layoutPickDayButtonBackground()
        layoutDatePicker()
        layoutPickDayButtonGradientView()
        layoutSelectedDayFrameView()
        layoutCollectionFadeView()
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
    
    private func layoutPickDayButtonBackground() {
        pickDayButtonBackground.pin
            .left()
            .top()
            .bottom()
            .width(31)
    }
    
    private func layoutDatePicker() {
        datePicker.frame = pickDayButtonBackground.frame
    }
    
    private func layoutPickDayButtonGradientView() {
        pickDayButtonGradientView.pin
            .top()
            .bottom()
            .left(to: pickDayButtonBackground.edge.right)
            .width(40)
        pickDayButtonGradientLayer.frame = pickDayButtonGradientView.bounds
    }
    
    private func layoutSelectedDayFrameView() {
        selectedDayFrameView.pin
            .right()
            .top()
            .bottom()
            .width(cellWidth)
    }
    
    private func layoutCollectionFadeView() {
        collectionFadeView.pin
            .left(to: collectionView.edge.left)
            .right(to: selectedDayFrameView.edge.left)
            .top()
            .bottom()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: collectionFadeView.frame.width, bottom: 0, right: 0)
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        pickDayButtonBackground.backgroundColor = appearance.primaryBackground
        pickDayButtonIcon.tintColor = appearance.primaryText
        pickDayButtonGradientLayer.colors = [appearance.primaryBackground.withAlphaComponent(1).cgColor, appearance.primaryBackground.withAlphaComponent(0).cgColor]
        selectedDayFrameView.layer.borderColor = appearance.secondaryBackground.cgColor
        collectionFadeView.backgroundColor = appearance.primaryBackground.withAlphaComponent(0.4)
        findDateCells().forEach { $0.setAppearance(appearance) }
    }
    
    // MARK: - Create date cell
    
    private let dateCellIdentifier = "dateCellIdentifier"
    
    func createDateCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateCellIdentifier, for: indexPath)
        (cell as? AppearanceCollectionViewCell)?.setAppearance(appearance)
        return cell
    }
    
    private let cellWidth: CGFloat = 54
    
    func getDateCellSize() -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    private func findDateCells() -> [DateCell] {
        return collectionView.visibleCells.compactMap { $0 as? DateCell }
    }
    
    // MARK: - Scroll
    
    func findNearestCellIndexPathUnderSelectedDayFrameView() -> IndexPath? {
        let selectionViewFrameTranslatedToCollectionView = self.convert(selectedDayFrameView.frame, to: collectionView)
        let scrollThresholdPoint = CGPoint(x: selectionViewFrameTranslatedToCollectionView.midX, y: selectionViewFrameTranslatedToCollectionView.midY)
        return collectionView.indexPathForItem(at: scrollThresholdPoint)
    }
    
    func showSelected(indexPath: IndexPath) {
        if collectionView.visibleCells.isNonEmpty {
            collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        } else {
            showSelectedIndexPathIfNoVisibleCellsYet(indexPath: indexPath)
        }
    }
    
    private func showSelectedIndexPathIfNoVisibleCellsYet(indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        })
    }
}
