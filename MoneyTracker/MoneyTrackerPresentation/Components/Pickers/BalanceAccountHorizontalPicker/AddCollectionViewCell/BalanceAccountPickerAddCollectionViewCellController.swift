//
//  AddCollectionViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 31.03.2022.
//

import UIKit
import AUIKit

extension BalanceAccountHorizontalPickerController {
final class AddCollectionViewCellController: AUIClosuresCollectionViewCellController {
    
    // MARK: Data
        
    let text: String
    private(set) var appearance: Appearance
    
    // MARK: Initializer
    
    init(text: String, appearance: Appearance) {
        self.text = text
        self.appearance = appearance
    }
    
    // MARK: MonthCollectionViewCell
    
    var addCollectionViewCell: AddCollectionViewCell? {
        return collectionViewCell as? AddCollectionViewCell
    }
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.cellForItemAtIndexPath(indexPath)
        setContent()
        setAppearance(appearance)
        return cell
    }
    
    override func willDisplayCell(_ cell: UICollectionViewCell) {
        super.willDisplayCell(cell)
        setContent()
    }
    
    // MARK: Content
    
    private func setContent() {
        addCollectionViewCell?.textLabel.text = text
    }
    
    static func text(_ text: String) -> String {
        return text
    }
    
    // MARK: - Appearance
    
    func setAppearance(_ appearance: Appearance) {
        addCollectionViewCell?.setAppearance(appearance)
    }

}
}
