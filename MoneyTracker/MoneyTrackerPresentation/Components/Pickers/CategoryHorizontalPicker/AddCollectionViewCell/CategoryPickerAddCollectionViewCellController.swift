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
        
    let text: String
    
    // MARK: Initializer
    
    init(text: String) {
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

}
}
