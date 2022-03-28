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
    
    // MARK: Initializer
    
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
        collectionViewFlowLayout.scrollDirection = .horizontal
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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionViewFlowLayout.minimumInteritemSpacing = 12
        if let deferredScrollToItemClosure = deferredScrollToItemClosure {
            deferredScrollToItemClosure()
            self.deferredScrollToItemClosure = nil
        }
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
    
    // MARK: Actions
    
    private var deferredScrollToItemClosure: (() -> ())?
    func collectionViewScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        if frame == .zero {
            deferredScrollToItemClosure = { [weak self] in
                guard let self = self else { return }
                self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
            }
        }
    }
    
}
}
