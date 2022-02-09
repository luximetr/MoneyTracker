//
//  AccountsScreenAccountCollectionViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 09.02.2022.
//

import UIKit
import AUIKit

extension AccountsScreenViewController {
final class AccountCollectionViewCellController: AUIClosuresCollectionViewCellController {
        
    // MARK: Data
        
    let account: Any
    
    // MARK: Initializer
        
    init(account: Any) {
        self.account = account
        super.init()
    }

}
}
