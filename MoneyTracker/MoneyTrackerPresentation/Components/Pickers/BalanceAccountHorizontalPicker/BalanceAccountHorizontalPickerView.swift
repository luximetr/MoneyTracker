//
//  BalanceAccountHorizontalPickerView.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 12.03.2022.
//

import UIKit
import AUIKit
import PinLayout

class BalanceAccountHorizontalPickerView: AppearanceView {
    
    // MARK: - UI elements
    
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
    }
    
    private let addCollectionViewCellReuseIdentifier = "addCollectionViewCellReuseIdentifier"
    private func setupCollectionView() {
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(BalanceAccountHorizontalPickerItemCell.self, forCellWithReuseIdentifier: itemCellIdentifier)
        collectionView.register(BalanceAccountHorizontalPickerController.AddCollectionViewCell.self, forCellWithReuseIdentifier: addCollectionViewCellReuseIdentifier)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(collectionView)
        layoutCollectionView()
    }
    
    private func layoutCollectionView() {
        collectionView.pin.all()
        if let deferredScrollToItemClosure = deferredScrollToItemClosure {
            deferredScrollToItemClosure()
            self.deferredScrollToItemClosure = nil
        }
    }
    
    // MARK: - Item cell
    
    private let itemCellIdentifier = "itemCellIdentifier"
    
    func createItemCell(indexPath: IndexPath, account: Account, isSelected: Bool) -> BalanceAccountHorizontalPickerItemCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellIdentifier, for: indexPath) as! BalanceAccountHorizontalPickerItemCell
        cell.color = account.backgroundColor
        cell.titleLabel.text = account.name
        cell.update(isSelected: isSelected)
        return cell
    }
    
    func getItemCellSize() -> CGSize {
        let minCellWidth: CGFloat = 1
        return CGSize(width: minCellWidth, height: collectionView.frame.height)
    }
    
    // MARK: AddCollectionViewCell
    
    func createAddCollectionViewCell(indexPath: IndexPath) -> BalanceAccountHorizontalPickerController.AddCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addCollectionViewCellReuseIdentifier, for: indexPath) as! BalanceAccountHorizontalPickerController.AddCollectionViewCell
        return cell
    }
    
    func addCollectionViewCellSize(_ text: String) -> CGSize {
        let size = BalanceAccountHorizontalPickerController.AddCollectionViewCell.sizeThatFits(collectionView.bounds.size, text: text)
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
    }
    
}
