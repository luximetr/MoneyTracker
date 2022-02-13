//
//  AccountsScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 08.02.2022.
//

import UIKit
import AUIKit

final class AccountsScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: Subviews
    
    let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let collectionView: UICollectionView
    
    // MARK: Initializer
    
    init() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        super.init()
    }
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.white
        insertSubview(collectionView, belowSubview: navigationBarView)
        setupCollectionView()
    }
    
    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = Colors.white
    }
    
    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = Colors.white
    }
    
    private let addAccountCollectionViewCellReuseIdentifier = "addAccountCollectionViewCellReuseIdentifier"
    private let accountCollectionViewCellReuseIdentifier = "accountCollectionViewCellReuseIdentifier"
    private func setupCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.register(AddAccountCollectionViewCell.self, forCellWithReuseIdentifier: addAccountCollectionViewCellReuseIdentifier)
        collectionView.register(AccountCollectionViewCell.self, forCellWithReuseIdentifier: accountCollectionViewCellReuseIdentifier)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCollectionView()
    }
    
    private func layoutCollectionView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let width = bounds.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        collectionView.frame = frame
        collectionViewFlowLayout.minimumLineSpacing = 13
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: AddAccountCollectionViewCell
    
    func addAccountCollectionViewCell(_ indexPath: IndexPath) -> AddAccountCollectionViewCell {
        let addAccountCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: addAccountCollectionViewCellReuseIdentifier, for: indexPath) as! AddAccountCollectionViewCell
        return addAccountCollectionViewCell
    }

    func addAccountCollectionViewCellSize() -> CGSize {
        let width = bounds.width - 16 * 2
        let height: CGFloat = 44
        let size = CGSize(width: width, height: height)
        return size
    }
    
    // MARK: AccountCollectionViewCell
    
    func accountCollectionViewCell(_ indexPath: IndexPath) -> AccountCollectionViewCell {
        let accountCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: accountCollectionViewCellReuseIdentifier, for: indexPath) as! AccountCollectionViewCell
        return accountCollectionViewCell
    }

    func accountCollectionViewCellSize() -> CGSize {
        let width = bounds.width - 16 * 2
        let height: CGFloat = 66
        let size = CGSize(width: width, height: height)
        return size
    }
    
}
