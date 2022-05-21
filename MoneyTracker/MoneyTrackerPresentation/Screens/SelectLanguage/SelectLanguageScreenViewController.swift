//
//  SelectLanguageScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.04.2022.
//

import UIKit
import AUIKit

final class SelectLanguageScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Currency - Data
    
    private let languages: [Language]
    private var selectedLanguage: Language
    var backClosure: (() -> Void)?
    var didSelectLanguageClosure: ((Language) throws -> Void)?
    
    // MARK: - Initializer
    
    init(appearance: Appearance, languages: [Language], locale: Locale) {
        self.languages = languages
        self.selectedLanguage = locale.language
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: - View
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private var screenView: ScreenView! {
        return view as? ScreenView
    }
    
    private let tableViewController = AUIEmptyTableViewController()
    private let sectionController = AUIEmptyTableViewSectionController()
    private var languageCellControllers: [LanguageTableViewCellController]? {
        let cellControllers = sectionController.cellControllers
        let languageCellControllers = cellControllers as? [LanguageTableViewCellController]
        return languageCellControllers
    }
    private func languageCellController(_ language: Language) -> LanguageTableViewCellController? {
        let languageCellController = languageCellControllers?.first(where: { $0.language == language })
        return languageCellController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupTableViewController()
        setContent()
    }
    
    private func setupTableViewController() {
        tableViewController.tableView = screenView.tableView
    }
    
    // MARK: - Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    private func didSelectLanguage(_ language: Language) {
        guard let didSelectLanguageClosure = didSelectLanguageClosure else { return }
        guard selectedLanguage != language else { return }
        do {
            try didSelectLanguageClosure(language)
            let currentSelectedCellController = languageCellController(selectedLanguage)
            currentSelectedCellController?.setIsSelected(false)
            let selectedCellController = languageCellController(language)
            selectedCellController?.setIsSelected(true)
            selectedLanguage = language
            localizer.changeLanguage(language)
            languageNameLocalizer.changeLanguage(language)
            languageCodeLocalizer.changeLanguage(language)
            setContent()
            tableViewController.reload()
        } catch { }
    }
    
    // MARK: Content
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: selectedLanguage, stringsTableName: "SelectLanguageScreenStrings")
        return localizer
    }()
    
    private lazy var languageCodeLocalizer: LanguageCodeLocalizer = {
        let localizer = LanguageCodeLocalizer(language: selectedLanguage)
        return localizer
    }()
    
    private lazy var languageNameLocalizer: LanguageNameLocalizer = {
        let localizer = LanguageNameLocalizer(language: selectedLanguage)
        return localizer
    }()
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("title")
        setTableViewContent()
    }
    
    private func setTableViewContent() {
        var cellControllers: [AUITableViewCellController] = []
        for language in languages {
            let isSelected = language == selectedLanguage
            let cellController = LanguageTableViewCellController(appearance: appearance, language: language, isSelected: isSelected, languageNameLocalizer: languageNameLocalizer, languageCodeLocalizer: languageCodeLocalizer)
            cellController.cellForRowAtIndexPathClosure = { [weak self] indexPath in
                guard let self = self else { return UITableViewCell() }
                let cell = self.screenView.languageTableViewCell(indexPath)
                return cell
            }
            cellController.estimatedHeightClosure = { [weak self] in
                guard let self = self else { return 0 }
                return self.screenView.languageTableViewCellEstimatedHeight()
            }
            cellController.heightClosure = { [weak self] in
                guard let self = self else { return 0 }
                return self.screenView.languageTableViewCellHeight()
            }
            cellController.didSelectClosure = { [weak self] in
                guard let self = self else { return }
                self.didSelectLanguage(language)
            }
            cellControllers.append(cellController)
        }
        sectionController.cellControllers = cellControllers
        tableViewController.sectionControllers = [sectionController]
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
        languageCellControllers?.forEach { $0.setAppearance(appearance) }
    }
}
