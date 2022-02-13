//
//  AccountsScreenAddAccountCollectionViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.02.2022.
//

import UIKit
import AUIKit

extension AccountsScreenViewController {
final class AddAccountCollectionViewCellController: AUIClosuresCollectionViewCellController {

    // MARK: Initializer
        
    init(localizer: ScreenLocalizer) {
        self.localizer = localizer
        super.init()
    }
    
    // MARK Collection View Cell
    
    var addAccountCollectionViewCell: AccountsScreenView.AddAccountCollectionViewCell? {
        return collectionViewCell as? AccountsScreenView.AddAccountCollectionViewCell
    }
    
    override func setupCollectionViewCell() {
        setContent()
    }
    
    // MARK: Localizer
    
    private let localizer: ScreenLocalizer
    
    // MARK: Conten
    
    private func setContent() {
        addAccountCollectionViewCell?.textLabel.text = localizer.localizeText("addAccount")
    }
}
}
