//
//  SelectAppearanceScreenAppearanceTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 20.04.2022.
//

import UIKit
import AUIKit

extension SelectAppearanceScreenViewController {
final class AppearanceSettingTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: - Data
    
    private(set) var appearance: Appearance
    let appearanceSetting: AppearanceSetting
    var isSelected: Bool = false
    
    // MARK: - Initializer
    
    init(appearance: Appearance, appearanceSetting: AppearanceSetting, isSelected: Bool, appearanceTypeNameLocalizer: AppearanceSettingNameLocalizer) {
        self.appearance = appearance
        self.appearanceSetting = appearanceSetting
        self.isSelected = isSelected
        self.appearanceTypeNameLocalizer = appearanceTypeNameLocalizer
    }
    
    // MARK: - LanguageTableViewCell
    
    private var appearanceSettingTableViewCell: AppearanceSettingTableViewCell? {
        return tableViewCell as? AppearanceSettingTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = super.cellForRowAtIndexPath(indexPath) as? AppearanceSettingTableViewCell else { return UITableViewCell() }
        setContent()
        cell.setIsSelected(isSelected, animated: false)
        return cell
    }
    
    // MARK: - Events
    
    func setIsSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
        appearanceSettingTableViewCell?.setIsSelected(isSelected, animated: true)
    }
        
    // MARK: - Content
    
    private let appearanceTypeNameLocalizer: AppearanceSettingNameLocalizer
    
    private func setContent() {
        appearanceSettingTableViewCell?.nameLabel.text = appearanceTypeNameLocalizer.name(appearanceSetting)
    }
    
    // MARK: - Appearance
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        appearanceSettingTableViewCell?.setAppearance(appearance)
        appearanceSettingTableViewCell?.setIsSelected(isSelected, animated: true)
    }
    
}
}
