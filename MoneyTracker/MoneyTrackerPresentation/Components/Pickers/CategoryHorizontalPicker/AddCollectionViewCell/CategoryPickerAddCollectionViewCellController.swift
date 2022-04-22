//
//  AddCollectionViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 29.03.2022.
//

import UIKit
import AUIKit

extension CategoryHorizontalPickerController {
final class AddCollectionViewCellController: AUIClosuresCollectionViewCellController {
    
    // MARK: Data
    
    private(set) var appearance: Appearance
    let text: String
    
    // MARK: Initializer
    
    init(appearance: Appearance, text: String) {
        self.appearance = appearance
        self.text = text
    }
    
    // MARK: MonthCollectionViewCell
    
    var addCollectionViewCell: AddCollectionViewCell? {
        return collectionViewCell as? AddCollectionViewCell
    }
    
    override func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.cellForItemAtIndexPath(indexPath)
        setContent()
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
        self.appearance = appearance
        addCollectionViewCell?.setAppearance(appearance)
    }

}
}
