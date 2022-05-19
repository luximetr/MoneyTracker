//
//  UnexpectedErrorDetailsScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 17.02.2022.
//

import UIKit
import AUIKit

final class UnexpectedErrorDetailsScreenViewController: StatusBarScreenViewController {
    
    // MARK: Data
    
    private let error: Swift.Error
    
    // MARK: Initializer
    
    init(appearance: Appearance, language: Language, error: Swift.Error) {
        self.error = error
        super.init(appearance: appearance, language: language)
    }
    
    // MARK: Delegation
    
    var backClosure: (() -> Void)?
    var shareClosure: ((Data) -> Void)?
    
    // MARK: View
    
    override func loadView() {
        view = UnexpectedErrorDetailsScreenView(frame: .zero, appearance: appearance)
    }
    
    private var unexpectedErrorDetailsScreenView: UnexpectedErrorDetailsScreenView! {
        return view as? UnexpectedErrorDetailsScreenView
    }
        
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "UnexpectedErrorDetailsScreenStrings")
        return localizer
    }()
    
    override func changeLanguage(_ language: Language) {
        super.changeLanguage(language)
        setContent()
    }
    
    // MARK: Content
    
    private func setContent() {
        unexpectedErrorDetailsScreenView.titleLabel.text = localizer.localizeText("title")
    }
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unexpectedErrorDetailsScreenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        unexpectedErrorDetailsScreenView.shareButton.addTarget(self, action: #selector(shareButtonTouchUpInsideEventAction), for: .touchUpInside)
        unexpectedErrorDetailsScreenView.textView.text = String(reflecting: error)
        setContent()
    }
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    @objc private func shareButtonTouchUpInsideEventAction() {
        let errorString = String(reflecting: error)
        guard let errorStringData = errorString.data(using: .utf8) else { return }
        shareClosure?(errorStringData)
    }
    
}
