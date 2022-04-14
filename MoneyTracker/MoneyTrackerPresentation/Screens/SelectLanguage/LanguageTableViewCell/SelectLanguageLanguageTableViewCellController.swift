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
    
    // MARK: - Data
    
    let language: Language
    var isSelected: Bool = false
    
    func setIsSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
        languageTableViewCell?.setIsSelected(isSelected, animated: true)
    }
    
    // MARK: - Initializer
    
    init(language: Language, isSelected: Bool, languageNameLocalizer: LanguageNameLocalizer, languageCodeLocalizer: LanguageCodeLocalizer) {
        self.language = language
        self.isSelected = isSelected
        self.languageNameLocalizer = languageNameLocalizer
        self.languageCodeLocalizer = languageCodeLocalizer
    }
    
    // MARK: - LanguageTableViewCell
    
    private var languageTableViewCell: LanguageTableViewCell? {
        return tableViewCell as? LanguageTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = super.cellForRowAtIndexPath(indexPath) as? LanguageTableViewCell else { return UITableViewCell() }
        setContent()
        cell.setIsSelected(isSelected, animated: false)
        return cell
    }
        
    // MARK: - Content
    
    private let languageNameLocalizer: LanguageNameLocalizer
    private let languageCodeLocalizer: LanguageCodeLocalizer
    
    private func setContent() {
        languageTableViewCell?.nameLabel.text = languageNameLocalizer.name(language)
        languageTableViewCell?.codeLabel.text = languageCodeLocalizer.code(language)
    }
    
}
}
