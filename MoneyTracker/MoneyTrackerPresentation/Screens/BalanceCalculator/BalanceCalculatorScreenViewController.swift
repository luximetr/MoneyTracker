//
//  BalanceCalculatorScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 22.05.2022.
//

import UIKit
import AUIKit

final class BalanceCalculatorScreenViewController: StatusBarScreenViewController {
    
    // MARK: Data
    
    private var accounts: [Account]
    
    // MARK: Initializer
    
    init(appearance: Appearance, locale: Locale, accounts: [Account]) {
        self.accounts = accounts
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: Delegation
    
    var backClosure: (() -> Void)?
    var addAccountClosure: (() -> Void)?
    var editAccountClosure: ((Account) -> Void)?
    var deleteAccountClosure: ((Account) -> Void)?
    var orderAccountsClosure: (([Account]) -> Void)?
    
    // MARK: View
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private var screenView: ScreenView! {
        return view as? ScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupCollectionViewController()
        setContent()
    }
    
    private func setupCollectionViewController() {
        collectionViewController.collectionView = screenView.collectionView
    }
    
    // MARK: Subcomponents
    
    private let collectionViewController = AUIEmptyCollectionViewController()
    private let accountsSectionController = AUIEmptyCollectionViewSectionController()
    private let addAccountSectionController = AUIEmptyCollectionViewSectionController()
    
    // MARK: Localizer
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "BalanceCalculatorScreenStrings")
        return localizer
    }()
    
    override func changeLocale(_ locale: Locale) {
        super.changeLocale(locale)
        setContent()
    }
    
    // MARK: - Appearance
    
    override func changeAppearance(_ appearance: Appearance) {
        super.changeAppearance(appearance)
        screenView.changeAppearance(appearance)
        accountsCellControllers.forEach { $0.setAppearance(appearance) }
    }
    
    // MARK: Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    private func didSelectAccount(_ account: Account) {
        editAccountClosure?(account)
    }
    
    private func didDeleteAccount(_ account: Account, cellController: AUICollectionViewCellController) {
        deleteAccountClosure?(account)
        collectionViewController.deleteCellController(cellController, completion: nil)
    }
    
    func addAccount(_ account: Account) {
        accounts.append(account)
        let cellController = createAccountCollectionViewCellController(account: account)
        collectionViewController.appendCellController(cellController, toSectionController: accountsSectionController, completion: nil)
    }
    
    func editAccount(_ editedAccount: Account) {
        guard let index = accounts.firstIndex(where: { $0.id == editedAccount.id }) else { return }
        accounts[index] = editedAccount
        guard let cellController = accountsSectionController.cellControllers.first(where: { ($0 as? AccountCollectionViewCellController)?.account.id == editedAccount.id }) as? AccountCollectionViewCellController else { return }
        cellController.editAccount(editedAccount)
    }
    
    // MARK: Content
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("screenTitle")
        setCollectionViewControllerContent()
    }
    
    private func setCollectionViewControllerContent() {
        var accountCellControllers: [AUICollectionViewCellController] = []
        for account in accounts {
            let accountCellController = createAccountCollectionViewCellController(account: account)
            accountCellControllers.append(accountCellController)
        }
        accountsSectionController.cellControllers = accountCellControllers
        
        let sectionControllers = [accountsSectionController]
        collectionViewController.sectionControllers = sectionControllers
        collectionViewController.reload()
    }
    
    private func createAccountCollectionViewCellController(account: Account) -> AccountCollectionViewCellController {
        let cellController = AccountCollectionViewCellController(account: account, appearance: appearance)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            let accountCollectionViewCell = self.screenView.accountCollectionViewCell(indexPath)
            return accountCollectionViewCell
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            let size = self.screenView.accountCollectionViewCellSize()
            return size
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectAccount(cellController.account)
        }
        return cellController
    }
    
    private var accountsCellControllers: [AccountCollectionViewCellController] {
        return accountsSectionController.cellControllers.compactMap { $0 as? AccountCollectionViewCellController }
    }
    
}
