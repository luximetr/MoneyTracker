//
//  DashboardAccountPickerViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 02.04.2022.
//

import UIKit
import AUIKit

extension DashboardScreenViewController {
final class AccountPickerViewController: EmptyViewController {
    
    // MARK: Data

    var accounts: [Account] = []
    private(set) var appearance: Appearance
    
    // MARK: Initializer
    
    init(locale: MyLocale, appearance: Appearance, accounts: [Account]) {
        self.accounts = accounts
        self.appearance = appearance
        super.init(locale: locale)
    }
    
    // MARK: AccountPickerView
  
    var accountPickerView: AccountPickerView? {
        set { view = newValue }
        get { return view as? AccountPickerView }
    }
    
    private let collectionController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
    private var accountsCellControllers: [BalanceAccountHorizontalPickerItemCellController]? {
        let accountsCellControllers = sectionController.cellControllers.filter({ $0 is BalanceAccountHorizontalPickerItemCellController }) as? [BalanceAccountHorizontalPickerItemCellController]
        return accountsCellControllers
    }
    private func accountCellController(_ account: Account) -> BalanceAccountHorizontalPickerItemCellController? {
        let accountCellController = accountsCellControllers?.first(where: { $0.account == account })
        return accountCellController
    }
    private var addCellController: BalanceAccountHorizontalPickerController.AddCollectionViewCellController? {
        return sectionController.cellControllers.first(where: { $0 is BalanceAccountHorizontalPickerController.AddCollectionViewCellController }) as? BalanceAccountHorizontalPickerController.AddCollectionViewCellController
    }
  
    override func setupView() {
        super.setupView()
        setupAccountPickerView()
    }
    
    func setupAccountPickerView() {
        accountPickerView?.transferButton.addTarget(self, action: #selector(transferButtonTouchUpInsideEventAction), for: .touchUpInside)
        collectionController.collectionView = accountPickerView?.collectionView
        setContent()
    }

    override func unsetupView() {
        super.unsetupView()
        unsetupAccountPickerView()
    }
  
    func unsetupAccountPickerView() {
        collectionController.collectionView = nil
    }
    
    // MARK: Content
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: locale.language, stringsTableName: "DashboardAccountPickerStrings")
        return localizer
    }()
    
    override func changeLocale(_ locale: MyLocale) {
        super.changeLocale(locale)
        localizer.changeLanguage(locale.language)
        setContent()
    }
    
    private func setContent() {
        accountPickerView?.titleLabel.text = localizer.localizeText("title")
        accountPickerView?.transferButton.setTitle(localizer.localizeText("transfer"), for: .normal)
        accountPickerView?.layoutSubviews()
        setCollectionControllerContent()
    }
    
    private func setCollectionControllerContent() {
        var cellControllers: [AUICollectionViewCellController] = []
        for account in accounts {
            let cellController = createItemCellController(account: account)
            cellControllers.append(cellController)
        }
        let addCellController = createAddCellController(text: localizer.localizeText("add"))
        cellControllers.append(addCellController)
        sectionController.cellControllers = cellControllers
        collectionController.sectionControllers = [sectionController]
        collectionController.reload()
    }

    private func createItemCellController(account: Account) -> BalanceAccountHorizontalPickerItemCellController {
        let cellController = BalanceAccountHorizontalPickerItemCellController(account: account, isSelected: false, appearance: appearance)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.accountPickerView!.accountCollectionViewCell(indexPath: indexPath)
        }
        cellController.sizeForCellClosure = { [weak self, weak cellController] in
            guard let self = self else { return .zero }
            guard let cellController = cellController else { return .zero }
            let name = cellController.account.name
            return self.accountPickerView!.accountCollectionViewCellSize(name: name)
        }
        cellController.didSelectClosure = { [weak self, weak cellController] in
            guard let self = self else { return }
            guard let cellController = cellController else { return }
            self.didSelectAccountCellController(cellController)
        }
        return cellController
    }
    
    private func createAddCellController(text: String) -> BalanceAccountHorizontalPickerController.AddCollectionViewCellController {
        let cellController = BalanceAccountHorizontalPickerController.AddCollectionViewCellController(text: text, appearance: appearance)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.accountPickerView!.addCollectionViewCell(indexPath: indexPath)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.accountPickerView!.addCollectionViewCellSize(BalanceAccountHorizontalPickerController.AddCollectionViewCellController.text(text))
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.addAccount()
        }
        return cellController
    }
    
    // MARK: - Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        accountsCellControllers?.forEach { $0.setAppearance(appearance) }
        addCellController?.setAppearance(appearance)
    }
    
    // MARK: Events
    
    func addAccount(_ account: Account) {
        accounts.append(account)
        setContent()
    }
    
    func addAccounts(_ accounts: [Account]) {
        guard !accounts.isEmpty else { return }
        self.accounts.append(contentsOf: accounts)
        setContent()
    }
    
    func editAccount(_ account: Account) {
        guard let firstIndex = accounts.firstIndex(where: { $0.id == account.id }) else { return }
        accounts[firstIndex] = account
        setContent()
    }
    
    func deleteAccount(_ account: Account) {
        guard let firstIndex = accounts.firstIndex(where: { $0.id == account.id }) else { return }
        accounts.remove(at: firstIndex)
        if let accountCellController = self.accountCellController(account) {
            collectionController.deleteCellController(accountCellController, completion: nil)
        }
    }
    
    func orderAccounts(_ accounts: [Account]) {
        self.accounts = accounts
        setContent()
    }
    
    var transferClosure: (() -> Void)?
    @objc private func transferButtonTouchUpInsideEventAction() {
        transferClosure?()
    }
    
    var selectAccountClosure: ((Account) -> Void)?
    private func didSelectAccountCellController(_ accountCellController: BalanceAccountHorizontalPickerItemCellController) {
        let account = accountCellController.account
        selectAccountClosure?(account)
    }
    
    var addAccountClosure: (() -> Void)?
    private func addAccount() {
        addAccountClosure?()
    }
    
}
}
