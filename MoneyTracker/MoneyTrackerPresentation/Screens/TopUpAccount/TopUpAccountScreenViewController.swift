//
//  TopUpAccountScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 05.04.2022.
//

import UIKit
import AUIKit
import MoneyTrackerStorage

final class TopUpAccountScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: - Data
    
    var selectedAccount: Account
    var backClosure: (() -> Void)?
    
    // MARK: Initializer
    
    init(selectedAccount: Account) {
        self.selectedAccount = selectedAccount
    }
    
    // MARK: - View
    
    private var screenView: ScreenView {
        return view as! ScreenView
    }
        
    override func loadView() {
        view = ScreenView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        setContent()
    }
    
    // MARK: Content
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "TopUpAccountScreenStrings")
        return localizer
    }()
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
    }
    
    // MARK: Events
    
    @objc
    private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
}
