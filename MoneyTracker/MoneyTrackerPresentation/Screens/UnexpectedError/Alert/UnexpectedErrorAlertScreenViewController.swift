//
//  UnexpectedErrorScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 16.02.2022.
//

import AFoundation
import AUIKit

final class UnexpectedErrorAlertScreenViewController: UIAlertController {
    
    // MARK: Delegation
    
    var seeDetailsClosure: (() -> Void)?
    var okClosure: (() -> Void)?
    
    // MARK: View
    
    override var preferredStyle: UIAlertController.Style {
        return .alert
    }
    
    // MARK: Language
    
    var language: Language!
    
    func changeLanguage(_ language: Language) {
        self.language = language
        setContent()
    }
    
    // MARK: Localizer
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(language: language, stringsTableName: "UnexpectedErrorAlertScreenStrings")
        return localizer
    }()
    
    // MARK: Content
    
    private func setContent() {
        title = localizer.localizeText("title")
        message = localizer.localizeText("message")
        let seeDetailsAlertAction = UIAlertAction(title: localizer.localizeText("seeDetails"), style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.seeDetailsAlertActionHandler()
        }
        addAction(seeDetailsAlertAction)
        let okAlertAction = UIAlertAction(title: localizer.localizeText("ok"), style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.okAlertActionHandler()
        }
        addAction(okAlertAction)
    }
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContent()
    }
    
    private func seeDetailsAlertActionHandler() {
        seeDetailsClosure?()
    }
    
    private func okAlertActionHandler() {
        okClosure?()
    }
    
}
