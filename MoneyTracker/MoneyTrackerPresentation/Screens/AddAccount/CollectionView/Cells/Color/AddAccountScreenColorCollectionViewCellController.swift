//
//  AddAccountScreenColorCollectionViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 11.02.2022.
//

import UIKit
import AUIKit

extension AddAccountScreenViewController {
final class ColorCollectionViewCellController: AUIClosuresCollectionViewCellController {
        
    // MARK: Data
        
    let color: Any
    
    // MARK: Initializer
        
    init(color: Any) {
        self.color = color
        super.init()
    }

}
}
