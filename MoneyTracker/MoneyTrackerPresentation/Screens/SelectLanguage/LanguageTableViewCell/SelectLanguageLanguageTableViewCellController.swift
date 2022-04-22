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
    
    private(set) var appearance: Appearance
    let language: Language
    var isSelected: Bool = false
    
    // MARK: - Initializer
    
    init(appearance: Appearance, language: Language, isSelected: Bool, languageNameLocalizer: LanguageNameLocalizer, languageCodeLocalizer: LanguageCodeLocalizer) {
        self.appearance = appearance
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
        setAppearance(appearance)
        return cell
    }
    
    // MARK: - Events
    
    func setIsSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
        languageTableViewCell?.setIsSelected(isSelected, animated: true)
    }
        
    // MARK: - Content
    
    private let languageNameLocalizer: LanguageNameLocalizer
    private let languageCodeLocalizer: LanguageCodeLocalizer
    
    private func setContent() {
        languageTableViewCell?.nameLabel.text = languageNameLocalizer.name(language)
        languageTableViewCell?.codeLabel.text = languageCodeLocalizer.code(language)
    }
    
    // MARK: - Appearance
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        languageTableViewCell?.setAppearance(appearance)
        languageTableViewCell?.setIsSelected(isSelected, animated: true)
    }
}
}
