//
//  DashboardCategoriesPicker.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 02.04.2022.
//

import UIKit
import AUIKit

extension DashboardScreenViewController {
final class CategoryPickerView: AUIView {
    
    // MARK: Subviews
    
    let titleLabel = UILabel()
    let addButton = TextButton()
    private let collectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout()
    let collectionView: UICollectionView
    
    // MARK: Initializer
    
    override init(frame: CGRect = .zero) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        super.init(frame: frame)
    }
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.white
        addSubview(titleLabel)
        setupTitleLabel()
        addSubview(addButton)
        addSubview(collectionView)
        setupCollectionView()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Fonts.default(size: 18, weight: .regular)
        titleLabel.textColor = Colors.primaryText
    }
        
    private let categoryCollectionViewCellReuseIdentifier = "itemCellIdentifier"
    private func setupCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryHorizontalPickerItemCell.self, forCellWithReuseIdentifier: categoryCollectionViewCellReuseIdentifier)
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
        collectionViewFlowLayout.minimumInteritemSpacing = 2
        collectionViewFlowLayout.minimumLineSpacing = 2
    }
    
    // MARK: Size
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return size
    }
    
    // MARK: CategoryCollectionViewCell
    
    func categoryCollectionViewCell(indexPath: IndexPath) -> CategoryHorizontalPickerItemCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCollectionViewCellReuseIdentifier, for: indexPath) as! CategoryHorizontalPickerItemCell
        return cell
    }
    
    func categoryCollectionViewCellSize(name: String) -> CGSize {
        let size = CategoryHorizontalPickerItemCell.sizeThatFits(collectionView.bounds.size, name: name)
        return size
    }
    
}
}

private class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
