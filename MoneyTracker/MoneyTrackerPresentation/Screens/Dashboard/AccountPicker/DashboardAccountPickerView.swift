//
//  DashboardAccountPickerView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 02.04.2022.
//

import UIKit
import AUIKit

extension DashboardScreenViewController {
final class AccountPickerView: AppearanceView {
    
    // MARK: Subviews
    
    let titleLabel = UILabel()
    let transferButton: TextButton
    private let collectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout()
    let collectionView: UICollectionView
    
    // MARK: Initializer
    
    init(appearance: Appearance) {
        self.transferButton = TextButton(appearance: appearance)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        super.init(appearance: appearance)
    }
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(transferButton)
        addSubview(collectionView)
        setupCollectionView()
        changeAppearance(appearance)
    }
    
    private func setupTitleLabel() {
        titleLabel.font = appearance.fonts.primary(size: 18, weight: .regular)
    }
    
    private let accountCollectionViewCellReuseIdentifier = "accountCollectionViewCellReuseIdentifier"
    private let addCollectionViewCellReuseIdentifier = "addCollectionViewCellReuseIdentifier"
    private func setupCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(BalanceAccountHorizontalPickerItemCell.self, forCellWithReuseIdentifier: accountCollectionViewCellReuseIdentifier)
        collectionView.register(BalanceAccountHorizontalPickerController.AddCollectionViewCell.self, forCellWithReuseIdentifier: addCollectionViewCellReuseIdentifier)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
        layoutAddButton()
        layoutCollectionView()
    }
    
    private func layoutTitleLabel() {
        let x: CGFloat = 22
        let y: CGFloat = 0
        let sizeThatFits = titleLabel.sizeThatFits(CGSize(width: (bounds.width - x) * 0.5, height: bounds.height))
        let width = sizeThatFits.width
        let height = sizeThatFits.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        titleLabel.frame = frame
    }
    
    private func layoutAddButton() {
        let y: CGFloat = 0
        let sizeThatFits = transferButton.sizeThatFits(CGSize(width: (bounds.width - 22) * 0.5, height: titleLabel.frame.size.height))
        let width = sizeThatFits.width
        let x = bounds.width - 22 - width
        let height = titleLabel.frame.size.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        transferButton.frame = frame
    }
    
    private func layoutCollectionView() {
        let x: CGFloat = 0
        let y: CGFloat = titleLabel.frame.origin.y + titleLabel.frame.size.height + 10
        let width = bounds.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        collectionView.frame = frame
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 22, bottom: 5, right: 22)
        collectionViewFlowLayout.minimumInteritemSpacing = 3
        collectionViewFlowLayout.minimumLineSpacing = 3
    }
    
    // MARK: - AccountCollectionViewCell
    
    func accountCollectionViewCell(indexPath: IndexPath) -> BalanceAccountHorizontalPickerItemCell {
        let accountCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: accountCollectionViewCellReuseIdentifier, for: indexPath) as! BalanceAccountHorizontalPickerItemCell
        accountCollectionViewCell.setAppearance(appearance)
        return accountCollectionViewCell
    }
    
    func accountCollectionViewCellSize(name: String) -> CGSize {
        let size = BalanceAccountHorizontalPickerItemCell.sizeThatFits(collectionView.bounds.size, name: name)
        return size
    }
    
    // MARK: AddCollectionViewCell
    
    func addCollectionViewCell(indexPath: IndexPath) -> BalanceAccountHorizontalPickerController.AddCollectionViewCell {
        let addCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: addCollectionViewCellReuseIdentifier, for: indexPath) as! BalanceAccountHorizontalPickerController.AddCollectionViewCell
        addCollectionViewCell.setAppearance(appearance)
        return addCollectionViewCell
    }
    
    func addCollectionViewCellSize(_ text: String) -> CGSize {
        let size = BalanceAccountHorizontalPickerController.AddCollectionViewCell.sizeThatFits(collectionView.bounds.size, text: text)
        return size
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        titleLabel.textColor = appearance.primaryText
        transferButton.setTitleColor(appearance.accent, for: .normal)
        collectionView.backgroundColor = appearance.colors.primaryBackground
    }
    
}
}
