//
//  LeftAlignedCollectionViewFlowLayout.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 02.04.2022.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesForElements = super.layoutAttributesForElements(in: rect)
        let attributesForElementsCopy = attributesForElements?.map({ $0.copy() as! UICollectionViewLayoutAttributes })
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributesForElementsCopy?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributesForElementsCopy
    }
}
