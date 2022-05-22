//
//  BalanceCalculatorScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 22.05.2022.
//

import UIKit
import AUIKit

extension BalanceCalculatorScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: Initializer
    
    init(appearance: Appearance) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        super.init(appearance: appearance)
    }
    
    // MARK: Subviews
    
    let balanceLabel = UILabel()
    let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let collectionView: UICollectionView
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.colors.primaryBackground
        addSubview(balanceLabel)
        setupBalanceLabel()
        insertSubview(collectionView, belowSubview: navigationBarView)
        setupCollectionView()
        setupAccountCollectionViewCell()
    }
    
    private func setupBalanceLabel() {
        balanceLabel.font = appearance.fonts.primary(size: 24, weight: .medium)
        balanceLabel.textColor = appearance.colors.primaryText
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = appearance.colors.primaryBackground
        collectionView.alwaysBounceVertical = true
    }
    
    private let accountCollectionViewCellReuseIdentifier = "accountCollectionViewCellReuseIdentifier"
    private func setupAccountCollectionViewCell() {
        collectionView.register(AccountCollectionViewCell.self, forCellWithReuseIdentifier: accountCollectionViewCellReuseIdentifier)
    }
        
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBalanceLabel()
        layoutCollectionView()
    }
    
    private func layoutBalanceLabel() {
        let x: CGFloat = 20
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height + 28
        let width = bounds.width - x * 2
        let height: CGFloat = 22
        let frame = CGRect(x: x, y: y, width: width, height: height)
        balanceLabel.frame = frame
        balanceLabel.textAlignment = .center
    }
    
    private func layoutCollectionView() {
        let x: CGFloat = 0
        let y = balanceLabel.frame.maxY + 28
        let width = bounds.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        collectionView.frame = frame
        collectionViewFlowLayout.minimumLineSpacing = 13
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: AccountCollectionViewCell
    
    func accountCollectionViewCell(_ indexPath: IndexPath) -> AccountCollectionViewCell {
        let accountCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: accountCollectionViewCellReuseIdentifier, for: indexPath) as! AccountCollectionViewCell
        accountCollectionViewCell.setAppearance(appearance)
        return accountCollectionViewCell
    }

    func accountCollectionViewCellSize() -> CGSize {
        let width = bounds.width - 16 * 2
        let height: CGFloat = 66
        let size = CGSize(width: width, height: height)
        return size
    }
    
    // MARK: Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        collectionView.backgroundColor = appearance.colors.primaryBackground
    }
    
}
}
