//
//  MonthPickerView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 25.03.2022.
//

import UIKit
import AUIKit

extension StatisticScreenViewController {
final class MonthPickerView: AUIView {
    
    // MARK: Subviews
    
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    let collectionView: UICollectionView
    
    override init(frame: CGRect = .zero) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        super.init(frame: frame)
    }
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        addSubview(collectionView)
        setupCollectionView()
    }
    
    private let monthCollectionViewCellReuseIdentifier = "monthCollectionViewCellReuseIdentifier"
    private func setupCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: monthCollectionViewCellReuseIdentifier)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCollectionView()
    }
    
    private func layoutCollectionView() {
        collectionView.frame = bounds
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 20)
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumInteritemSpacing = 16
    }
    
    // MARK: MonthCollectionViewCell
    
    func monthCollectionViewCell(_ indexPath: IndexPath) -> MonthCollectionViewCell {
        let accountCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: monthCollectionViewCellReuseIdentifier, for: indexPath) as! MonthCollectionViewCell
        return accountCollectionViewCell
    }

    func monthCollectionViewCellSize(_ month: String) -> CGSize {
        let size = MonthCollectionViewCell.sizeThatFits(collectionView.bounds.size, month: month)
        return size
    }
    
}
}
