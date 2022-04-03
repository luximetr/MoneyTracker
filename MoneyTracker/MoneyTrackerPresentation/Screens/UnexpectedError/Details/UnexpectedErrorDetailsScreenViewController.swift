//
//  UnexpectedErrorDetailsScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 17.02.2022.
//

import UIKit
import AUIKit

final class UnexpectedErrorDetailsScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Data
    
    private let error: Swift.Error
    
    // MARK: Initializer
    
    init(error: Swift.Error) {
        self.error = error
        super.init()
    }
    
    // MARK: Delegation
    
    var backClosure: (() -> Void)?
    var shareClosure: ((Data) -> Void)?
    
    // MARK: View
    
    override func loadView() {
        view = UnexpectedErrorDetailsScreenView()
    }
    
    private var unexpectedErrorDetailsScreenView: UnexpectedErrorDetailsScreenView! {
        return view as? UnexpectedErrorDetailsScreenView
    }
        
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "UnexpectedErrorDetailsScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unexpectedErrorDetailsScreenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        unexpectedErrorDetailsScreenView.shareButton.addTarget(self, action: #selector(shareButtonTouchUpInsideEventAction), for: .touchUpInside)
        unexpectedErrorDetailsScreenView.titleLabel.text = localizer.localizeText("title")
        unexpectedErrorDetailsScreenView.textView.text = String(reflecting: error)
    }
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    @objc private func shareButtonTouchUpInsideEventAction() {
        let errorString = String(reflecting: error)
        guard let errorStringData = errorString.data(using: .utf8) else { return }
        shareClosure?(errorStringData)
    }
    
    // MARK: Content
    
    private func setContent() {
        
    }
    
}
