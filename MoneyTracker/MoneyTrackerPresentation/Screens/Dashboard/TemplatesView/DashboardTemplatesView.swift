//
//  TemplatesView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 01.04.2022.
//

import UIKit
import AUIKit

extension DashboardScreenViewController {
final class TemplatesView: AppearanceView {
    
    // MARK: - Subviews
    
    let panGestureView = UIView()
    let titleLabel = UILabel()
    let addButton: TextButton
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    let collectionView: UICollectionView
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.addButton = TextButton(appearance: appearance)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        super.init(appearance: appearance)
    }
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        backgroundColor = appearance.primaryBackground
        addSubview(panGestureView)
        setupPanGestureView()
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(addButton)
        addSubview(collectionView)
        setupCollectionView()
        setupTemplateCollectionViewCell()
    }
    
    private func setupPanGestureView() {
        panGestureView.backgroundColor = appearance.secondaryBackground
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Fonts.default(size: 18, weight: .regular)
        titleLabel.textColor = appearance.primaryText
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = appearance.primaryBackground
    }
        
    private let templateCollectionViewCellReuseIdentifier = "templateCollectionViewCellReuseIdentifier"
    private func setupTemplateCollectionViewCell() {
        collectionView.register(TemplateCollectionViewCell.self, forCellWithReuseIdentifier: templateCollectionViewCellReuseIdentifier)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layoutPanGestureView()
        layoutTitleLabel()
        layoutAddButton()
        layoutCollectionView()
    }
    
    private func layoutPanGestureView() {
        let width: CGFloat = 44
        let height: CGFloat = 4
        let x = (bounds.width - width) * 0.5
        let y: CGFloat = 10
        let frame = CGRect(x: x, y: y, width: width, height: height)
        panGestureView.frame = frame
        panGestureView.layer.cornerRadius = 2
    }
    
    private func layoutTitleLabel() {
        let x: CGFloat = 22
        let y: CGFloat = panGestureView.frame.origin.y + panGestureView.frame.size.height + 10
        let sizeThatFits = titleLabel.sizeThatFits(CGSize(width: (bounds.width - x) * 0.5, height: bounds.height))
        let width = sizeThatFits.width
        let height = sizeThatFits.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        titleLabel.frame = frame
    }
    
    private func layoutAddButton() {
        let y: CGFloat = panGestureView.frame.origin.y + panGestureView.frame.size.height + 10
        let sizeThatFits = addButton.sizeThatFits(CGSize(width: (bounds.width - 22) * 0.5, height: titleLabel.frame.size.height))
        let width = sizeThatFits.width
        let x = bounds.width - 22 - width
        let height = titleLabel.frame.size.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        addButton.frame = frame
    }
    
    private func layoutCollectionView() {
        let x: CGFloat = 0
        let y: CGFloat = titleLabel.frame.origin.y + titleLabel.frame.size.height + 10
        let width = bounds.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        collectionView.frame = frame
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 22, bottom: 5, right: 22)
        collectionViewFlowLayout.minimumLineSpacing = 10
    }
    
    // MARK: - Size
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var height: CGFloat = 0
        height += 10
        height += 4
        height += 10
        height += titleLabel.sizeThatFits(CGSize(width: (size.width - 22) * 0.5, height: bounds.height)).height
        height += 10
        if collectionView.numberOfItems(inSection: 0) > 0 {
            height += 5
        }
        if collectionView.numberOfItems(inSection: 0) >= 5 {
            height += 44
            height += 10
            height += 44
            height += 10
            height += 44
            height += 5
        } else if collectionView.numberOfItems(inSection: 0) >= 3 {
            height += 44
            height += 10
            height += 44
            height += 5
        } else if collectionView.numberOfItems(inSection: 0) >= 1 {
            height += 44
            height += 5
        }
        let width = size.width
        return CGSize(width: width, height: height)
    }
    
    // MARK: - TemplateCollectionViewCell
    
    func templateCollectionViewCell(indexPath: IndexPath) -> TemplateCollectionViewCell {
        let templateCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: templateCollectionViewCellReuseIdentifier, for: indexPath) as! TemplateCollectionViewCell
        templateCollectionViewCell.setAppearance(appearance)
        return templateCollectionViewCell
    }
    
    func templateCollectionViewCellSize() -> CGSize {
        let availableRowWidth = (bounds.width - 22 * 2 - 16) * 0.5
        return CGSize(width: availableRowWidth, height: 44)
    }
    
    private var visibleCollectionCells: [AppearanceCollectionViewCell] {
        return collectionView.visibleCells.compactMap { $0 as? AppearanceCollectionViewCell }
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        backgroundColor = appearance.primaryBackground
        panGestureView.backgroundColor = appearance.secondaryBackground
        titleLabel.textColor = appearance.primaryText
        collectionView.backgroundColor = appearance.primaryBackground
        visibleCollectionCells.forEach { $0.setAppearance(appearance) }
    }
    
}
}
