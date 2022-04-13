//
//  SelectLanguageLanguageTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.04.2022.
//

import UIKit
import AUIKit

extension SelectLanguageScreenViewController {
final class LanguageTableViewCellController: AUIClosuresTableViewCellController {
    
    let language: Language
    var isSelected: Bool = false
    
    init(language: Language, isSelected: Bool) {
        self.language = language
        self.isSelected = isSelected
    }
    
    private var languageTableViewCell: LanguageTableViewCell? {
        return tableViewCell as? LanguageTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = super.cellForRowAtIndexPath(indexPath) as? LanguageTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
}
}
