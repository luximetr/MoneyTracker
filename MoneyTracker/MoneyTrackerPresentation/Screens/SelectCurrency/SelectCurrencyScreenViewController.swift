//
//  SelectCurrencyScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.02.2022.
//

import UIKit
import AUIKit

class SelectCurrencyScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - View
    
    override func loadView() {
        view = SelectCurrencyScreenView()
    }
}
