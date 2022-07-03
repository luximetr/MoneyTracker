//
//  SelectAppearanceScreenAppearanceTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.07.2022.
//

import UIKit
import AUIKit

extension TotalAmountViewSettingScreenViewController {
final class TotalAmountViewSettingTableViewCellController: AUIClosuresTableViewCellController {
    
    // MARK: - Data
    
    private(set) var appearance: Appearance
    let appearanceSetting: TotalAmountViewSetting
    var isSelected: Bool = false
    
    // MARK: - Initializer
    
    init(appearance: Appearance, appearanceSetting: TotalAmountViewSetting, isSelected: Bool, appearanceTypeNameLocalizer: TotalAmountViewSettingNameLocalizer) {
        self.appearance = appearance
        self.appearanceSetting = appearanceSetting
        self.isSelected = isSelected
        self.appearanceTypeNameLocalizer = appearanceTypeNameLocalizer
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
    
    private let appearanceTypeNameLocalizer: TotalAmountViewSettingNameLocalizer
    
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
