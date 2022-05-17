//
//  MonthPickerView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 25.03.2022.
//

import UIKit
import AUIKit

extension StatisticScreenViewController {
final class MonthPickerView: AppearanceView {
    
    // MARK: - Subviews
    
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    let collectionView: UICollectionView
    private var monthTableViewCells: [MonthCollectionViewCell]? {
        let monthTableViewCells = collectionView.visibleCells.compactMap({ $0 as? MonthCollectionViewCell })
        return monthTableViewCells
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect = .zero, appearance: Appearance) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        super.init(frame: frame, appearance: appearance)
    }
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        backgroundColor = appearance.colors.primaryBackground
        addSubview(collectionView)
        setupCollectionView()
        setupMonthCollectionViewCell()
    }
    
    private func setupCollectionView() {
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionView.backgroundColor = appearance.colors.primaryBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
    }
    
    private let monthCollectionViewCellReuseIdentifier = "monthCollectionViewCellReuseIdentifier"
    private func setupMonthCollectionViewCell() {
        collectionView.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: monthCollectionViewCellReuseIdentifier)
    }
    
    // MARK: - Layout
    
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
    
    // MARK: - MonthCollectionViewCell
    
    func monthCollectionViewCell(_ indexPath: IndexPath) -> MonthCollectionViewCell {
        let monthCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: monthCollectionViewCellReuseIdentifier, for: indexPath) as! MonthCollectionViewCell
        monthCollectionViewCell.setAppearance(appearance)
        return monthCollectionViewCell
    }

    func monthCollectionViewCellSize(_ month: String) -> CGSize {
        let size = MonthCollectionViewCell.sizeThatFits(collectionView.bounds.size, month: month)
        return size
    }
    
    // MARK: - Actions
    
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
        backgroundColor = appearance.colors.primaryBackground
        collectionView.backgroundColor = appearance.colors.primaryBackground
        monthTableViewCells?.forEach({ $0.setAppearance(appearance) })
    }
    
}
}
