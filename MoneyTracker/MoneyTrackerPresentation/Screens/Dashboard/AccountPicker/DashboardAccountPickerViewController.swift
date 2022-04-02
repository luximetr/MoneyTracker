//
//  DashboardAccountPickerViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 02.04.2022.
//

import UIKit
import AUIKit

extension DashboardScreenViewController {
final class AccountPickerViewController: AUIEmptyViewController {
    
    // MARK: Data

    var accounts: [Account] = []
    
    // MARK: Initializer
    
    init(accounts: [Account]) {
        self.accounts = accounts
    }
    
    // MARK: CategoryPickerView
  
    var accountPickerView: AccountPickerView? {
        set { view = newValue }
        get { return view as? AccountPickerView }
    }
    
    private let collectionController = AUIEmptyCollectionViewController()
    private let sectionController = AUIEmptyCollectionViewSectionController()
  
    override func setupView() {
        super.setupView()
        setupCategoryPickerView()
    }
    
    func setupCategoryPickerView() {
        accountPickerView?.addButton.addTarget(self, action: #selector(addButtonTouchUpInsideEventAction), for: .touchUpInside)
        collectionController.collectionView = accountPickerView?.collectionView
        setContent()
    }

    override func unsetupView() {
        super.unsetupView()
        unsetupCategoryPickerView()
    }
  
    func unsetupCategoryPickerView() {
        collectionController.collectionView = nil
    }
    
    // MARK: Content
    
    private func setContent() {
        accountPickerView?.titleLabel.text = "Top up account"
        accountPickerView?.addButton.setTitle("Add expense", for: .normal)
//        setCollectionControllerContent()
    }
    
//    private func setCollectionControllerContent() {
//        var cellControllers: [AUICollectionViewCellController] = []
//        for account in accounts {
//            let cellController = createCategoryCellController(category: category)
//            cellControllers.append(cellController)
//        }
//        sectionController.cellControllers = cellControllers
//        collectionController.sectionControllers = [sectionController]
//        collectionController.reload()
//    }
//
//    private func createAccountCellController(account: Account) -> CategoryHorizontalPickerItemCellController {
//        let cellController = AccountHorizontalPickerItemCellController(category: category, isSelected: false)
//        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
//            guard let self = self else { return UICollectionViewCell() }
//            return self.categoryPickerView!.categoryCollectionViewCell(indexPath: indexPath)
//        }
//        cellController.sizeForCellClosure = { [weak self, cellController] in
//            guard let self = self else { return .zero }
//            let category = cellController.category
//            return self.categoryPickerView!.categoryCollectionViewCellSize(name: category.name)
//        }
//        cellController.didSelectClosure = { [weak self, cellController] in
//            guard let self = self else { return }
//            self.didSelectCategoryCellController(cellController)
//        }
//        return cellController
//    }
    
    // MARK: Events
    
    func addAccount(_ account: Account) {
        accounts.append(account)
        setContent()
    }
    
    var addAccountClosure: (() -> Void)?
    @objc private func addButtonTouchUpInsideEventAction() {
        addAccountClosure?()
    }
    
    var selectAccountClosure: ((Account) -> Void)?
    private func didSelectAccountCellController(_ accountCellController: BalanceAccountHorizontalPickerItemCellController) {
        let account = accountCellController.account
        selectAccountClosure?(account)
    }
    
}
}
