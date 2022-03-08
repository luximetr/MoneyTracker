//
//  DashboardScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 08.03.2022.
//

import UIKit
import AUIKit

class DashboardScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "DashboardScreenStrings")
        return localizer
    }()
    
    // MARK: - View
    
    private var dashboardScreenView: DashboardScreenView {
        return view as! DashboardScreenView
    }
    
    // MARK: - View - Life cycle
    
    override func loadView() {
        view = DashboardScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardScreenView.titleLabel.text = localizer.localizeText("title")
    }
}
