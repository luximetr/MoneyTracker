//
//  SelectAppearanceScreenAppearanceTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.07.2022.
//

import UIKit
import AUIKit

extension TotalAmountViewSettingsScreenViewController {
final class TotalAmountViewSettingTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: - Data
    
    private(set) var appearance: Appearance
    let totalAmountViewSetting: TotalAmountViewSetting
    let example: String
    var isSelected: Bool = false
    
    // MARK: - Initializer
    
    init(appearance: Appearance, totalAmountViewSetting: TotalAmountViewSetting, example: String, isSelected: Bool, totalAmountViewSettingNameLocalizer: TotalAmountViewSettingNameLocalizer) {
        self.appearance = appearance
        self.totalAmountViewSetting = totalAmountViewSetting
        self.example = example
        self.isSelected = isSelected
        self.totalAmountViewSettingNameLocalizer = totalAmountViewSettingNameLocalizer
    }
    
    // MARK: - LanguageTableViewCell
    
    private var appearanceSettingTableViewCell: TotalAmountViewSettingTableViewCell? {
        return tableViewCell as? TotalAmountViewSettingTableViewCell
    }
    
    override func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = super.cellForRowAtIndexPath(indexPath) as? TotalAmountViewSettingTableViewCell else { return UITableViewCell() }
        setContent()
        setAppearance(appearance)
        return cell
    }
    
    // MARK: - Events
    
    func setIsSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
        appearanceSettingTableViewCell?.setIsSelected(isSelected, animated: true)
    }
        
    // MARK: - Content
    
    private let totalAmountViewSettingNameLocalizer: TotalAmountViewSettingNameLocalizer
    
    private func setContent() {
        appearanceSettingTableViewCell?.nameLabel.text = totalAmountViewSettingNameLocalizer.name(totalAmountViewSetting)
        appearanceSettingTableViewCell?.exampleLabel.text = example
    }
    
    // MARK: - Appearance
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        appearanceSettingTableViewCell?.setAppearance(appearance)
        appearanceSettingTableViewCell?.setIsSelected(isSelected, animated: true)
    }
    
}
}
