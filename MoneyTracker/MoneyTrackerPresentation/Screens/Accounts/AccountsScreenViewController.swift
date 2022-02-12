//
//  AccountsScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 08.02.2022.
//

import UIKit
import AUIKit

final class AccountsScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Data
    
    private var accounts: [Account]
    
    // MARK: Initializer
    
    init(accounts: [Account]) {
        self.accounts = accounts
    }
    
    // MARK: Delegation
    
    var backClosure: (() -> Void)?
    var addClosure: (() -> Void)?
    var deleteAccountClosure: ((Account) -> Void)?
    
    // MARK: View
    
    override func loadView() {
        view = AccountsScreenView()
    }
    
    private var accountsScreenView: AccountsScreenView! {
        return view as? AccountsScreenView
    }
    
    private let collectionViewController = AUIEmptyCollectionViewController()
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "AccountsScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountsScreenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        accountsScreenView.titleLabel.text = localizer.localizeText("title")
        setupCollectionViewController()
    }
    
    private func setupCollectionViewController() {
        collectionViewController.collectionView = accountsScreenView.collectionView
        let sectionController = AUIEmptyCollectionViewSectionController()
        var cellControllers: [AUICollectionViewCellController] = []
        for account in accounts {
            let cellController = AccountCollectionViewCellController(account: account)
            cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
                guard let self = self else { return UICollectionViewCell() }
                let cell = self.accountsScreenView.accountCollectionViewCell(indexPath)
                cell?.accountView.backgroundColor = .green
                cell?.nameLabel.text = "ffgdfgdfg"
                return cell!
            }
            cellController.sizeForCellClosure = { [weak self] in
                guard let self = self else { return .zero }
                let size = self.accountsScreenView.accountCollectionViewCellSize()
                return size
            }
            cellController.didSelectClosure = { [weak self] in
                guard let self = self else { return }
                self.didSelectAccount(account)
            }
            cellController.didDeleteClosure = { [weak self] in
                guard let self = self else { return }
                self.didDeleteAccount(account, cellController: cellController)
            }
            
            cellControllers.append(cellController)
        }
        
        sectionController.cellControllers = cellControllers
        collectionViewController.sectionControllers = [sectionController]
    }
    
    // MARK: Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    private func didSelectAccount(_ account: Account) {
        print("didSelectAccount")
        addClosure?()
    }
    
    private func didDeleteAccount(_ account: Account, cellController: AUICollectionViewCellController) {
        deleteAccountClosure?(account)
        collectionViewController.deleteCellController(cellController)
    }
    
}
