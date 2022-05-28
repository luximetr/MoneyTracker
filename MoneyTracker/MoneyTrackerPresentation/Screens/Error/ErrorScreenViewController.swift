//
//  UnexpectedErrorDetailsScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 17.02.2022.
//

import UIKit
import AUIKit

final class ErrorScreenViewController: StatusBarScreenViewController {
    
    // MARK: Data
    
    private let error: Swift.Error
    
    // MARK: Initializer
    
    init(appearance: Appearance, locale: Locale, error: Swift.Error) {
        self.error = error
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: Delegation
    
    var backClosure: (() -> Void)?
    var shareClosure: ((Data) -> Void)?
    
    // MARK: View
    
    override func loadView() {
        view = ScreenView(frame: .zero, appearance: appearance)
    }
    
    private var screenView: ScreenView! {
        return view as? ScreenView
    }
        
    // MARK: Localizer
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "ErrorScreenStrings")
        return localizer
    }()
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        setContent()
    }
    
    // MARK: Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
    }
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.shareButton.addTarget(self, action: #selector(shareButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.textView.text = String(reflecting: error)
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
