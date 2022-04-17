//
//  BalanceAccountHorizontalPickerController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 12.03.2022.
//

import UIKit
import AUIKit

class BalanceAccountHorizontalPickerController: EmptyViewController {
    
    // MARK: - Delegations
    
    var didSelectAccountClosure: ((Account) -> Void)?
    
    // MARK: - Data
    
    var selectedAccount: Account?
    
    // MARK: - Controllers
    
    private let collectionController = AUIEmptyCollectionViewController()
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: language, stringsTableName: "BalanceAccountHorizontalPickerStrings")
        return localizer
    }()
    
    // MARK: - View
    
    var balanceAccountHorizontalPickerView: BalanceAccountHorizontalPickerView {
        set { view = newValue }
        get { return view as! BalanceAccountHorizontalPickerView }
    }
    
    // MARK: - View - Setup
    
    override func setupView() {
        super.setupView()
        collectionController.collectionView = balanceAccountHorizontalPickerView.collectionView
    }
    
    override func unsetupView() {
        super.unsetupView()
        collectionController.collectionView = nil
    }
    
    // MARK: - Configuration
    
    func showOptions(accounts: [Account], selectedAccount: Account) {
        self.selectedAccount = selectedAccount
        let sectionController = AUIEmptyCollectionViewSectionController()
        var cellControllers = createItemCellControllers(accounts: accounts, selectedAccount: selectedAccount)
        let addCellController = createAddCellController(text: localizer.localizeText("add"))
        cellControllers.append(addCellController)
        sectionController.cellControllers = cellControllers
        collectionController.sectionControllers = [sectionController]
        collectionController.reload()
        if let cellController = findCellControllerForAccountId(selectedAccount.id), let indexPath = collectionController.indexPathForCellController(cellController) {
            balanceAccountHorizontalPickerView.collectionViewScrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - Item cell controller - Create
    
    private func createItemCellControllers(accounts: [Account], selectedAccount: Account) -> [AUICollectionViewCellController] {
        return accounts.map { createItemCellController(account: $0, isSelected: $0.id == selectedAccount.id) }
    }
    
    private func createItemCellController(account: Account, isSelected: Bool) -> AUICollectionViewCellController {
        let cellController = BalanceAccountHorizontalPickerItemCellController(account: account, isSelected: isSelected)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.balanceAccountHorizontalPickerView.createItemCell(indexPath: indexPath, account: account, isSelected: isSelected)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.balanceAccountHorizontalPickerView.getItemCellSize()
        }
        cellController.didSelectClosure = { [weak self] in
            self?.didSelectAccount(account)
        }
        return cellController
    }
    
    private func createAddCellController(text: String) -> AddCollectionViewCellController {
        let cellController = AddCollectionViewCellController(text: text)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            return self.balanceAccountHorizontalPickerView.createAddCollectionViewCell(indexPath: indexPath)
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            return self.balanceAccountHorizontalPickerView.addCollectionViewCellSize(AddCollectionViewCellController.text(text))
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.addAccount()
        }
        return cellController
    }
    
    // MARK: - Item cell controller - Find
    
    private func findCellControllerForAccountId(_ accountId: AccountId) -> BalanceAccountHorizontalPickerItemCellController? {
        let cellControllers = collectionController.sectionControllers.map({ $0.cellControllers }).reduce([], +).compactMap { $0 as? BalanceAccountHorizontalPickerItemCellController }
        let foundCellController = cellControllers.first(where: { $0.account.id == accountId })
        return foundCellController
    }
    
    // MARK: - Item cell controller - Update
    
    private func showAccountSelected(_ account: Account) {
        guard let cellController = findCellControllerForAccountId(account.id) else { return }
        cellController.isSelected = true
    }
    
    private func showAccountDeselected(_ account: Account) {
        guard let cellController = findCellControllerForAccountId(account.id) else { return }
        cellController.isSelected = false
    }
    
    // MARK: - Item cell controller - Actions
    
    private func didSelectAccount(_ account: Account) {
        guard let selectedAccount = selectedAccount, selectedAccount.id != account.id else { return }
        showAccountDeselected(selectedAccount)
        self.selectedAccount = account
        showAccountSelected(account)
        didSelectAccountClosure?(account)
    }
    
    var addAccountClosure: (() -> Void)?
    private func addAccount() {
        addAccountClosure?()
    }
    
}
