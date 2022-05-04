//
//  AccountsScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 08.02.2022.
//

import UIKit
import AUIKit

extension AccountsScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: Initializer
    
    init(appearance: Appearance) {
        self.addButton = TextButton(appearance: appearance)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        super.init(appearance: appearance)
    }
    
    // MARK: Subviews
    
    let addButton: TextButton
    let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let collectionView: UICollectionView
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.primaryBackground
        navigationBarView.addSubview(addButton)
        setupAddButton()
        insertSubview(collectionView, belowSubview: navigationBarView)
        setupCollectionView()
        setupAccountCollectionViewCell()
    }
    
    private func setupAddButton() {
        addButton.titleLabel?.font = Fonts.default(size: 17)
        addButton.setTitleColor(appearance.accent, for: .normal)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = appearance.primaryBackground
        collectionView.alwaysBounceVertical = true
    }
    
    private let accountCollectionViewCellReuseIdentifier = "accountCollectionViewCellReuseIdentifier"
    private func setupAccountCollectionViewCell() {
        collectionView.register(AccountCollectionViewCell.self, forCellWithReuseIdentifier: accountCollectionViewCellReuseIdentifier)
    }
        
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutAddButton()
        layoutCollectionView()
    }
    
    private func layoutAddButton() {
        var size = navigationBarView.bounds.size
        size = addButton.sizeThatFits(size)
        let x = navigationBarView.bounds.width - size.width - 12
        let y = (navigationBarView.frame.size.height - size.height) * 0.5
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: size)
        addButton.frame = frame
    }
    
    private func layoutCollectionView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
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
        backgroundColor = appearance.primaryBackground
        collectionView.backgroundColor = appearance.primaryBackground
    }
    
}
}
