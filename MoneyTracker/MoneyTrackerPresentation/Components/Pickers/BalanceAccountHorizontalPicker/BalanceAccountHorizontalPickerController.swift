//
//  BalanceAccountHorizontalPickerController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 12.03.2022.
//

import UIKit
import AUIKit

class BalanceAccountHorizontalPickerController: AUIEmptyViewController {
    
    // MARK: - Delegations
    
    var didSelectAccountClosure: ((Account) -> Void)?
    
    // MARK: - Data
    
    var selectedAccount: Account?
    
    // MARK: - Controllers
    
    private let collectionController = AUIEmptyCollectionViewController()
    
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
        let cellControllers = createItemCellControllers(accounts: accounts, selectedAccount: selectedAccount)
        sectionController.cellControllers = cellControllers
        collectionController.sectionControllers = [sectionController]
        collectionController.reload()
    }
    
    // MARK: - Item cell controller - Create
    
    private func createItemCellControllers(accounts: [Account], selectedAccount: Account) -> [AUICollectionViewCellController] {
        return accounts.map { createItemCellController(account: $0, isSelected: $0.id == selectedAccount.id) }
    }
    
    private func createItemCellController(account: Account, isSelected: Bool) -> AUICollectionViewCellController {
        let cellController = BalanceAccountHorizontalPickerItemCellController(accountId: account.id, isSelected: isSelected)
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
    
    // MARK: - Item cell controller - Find
    
    private func findCellControllerForAccountId(_ accountId: AccountId) -> BalanceAccountHorizontalPickerItemCellController? {
        let cellControllers = collectionController.sectionControllers.map({ $0.cellControllers }).reduce([], +).compactMap { $0 as? BalanceAccountHorizontalPickerItemCellController }
        let foundCellController = cellControllers.first(where: { $0.accountId == accountId })
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
}
