//
//  AccountsScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 08.02.2022.
//

import UIKit
import AUIKit

final class AccountsScreenViewController: AUIStatusBarScreenViewController, UICollectionViewDropDelegate, UICollectionViewDragDelegate {
    
    // MARK: Data
    
    private var accounts: [Account]
    
    // MARK: Initializer
    
    init(accounts: [Account]) {
        self.accounts = accounts
    }
    
    // MARK: Delegation
    
    var backClosure: (() -> Void)?
    var addAccountClosure: (() -> Void)?
    var updateAccountClosure: ((Account) -> Void)?
    var deleteAccountClosure: ((Account) -> Void)?
    var orderAccountsClosure: (([Account]) -> Void)?
    
    // MARK: View
    
    override func loadView() {
        view = AccountsScreenView()
    }
    
    private var accountsScreenView: AccountsScreenView! {
        return view as? AccountsScreenView
    }
    
    // MARK: Subcomponents
    
    private let collectionViewController = AUIEmptyCollectionViewController()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        setupCollectionViewController()
    }
    
    private func setupCollectionViewController() {
        collectionViewController.collectionView = accountsScreenView.collectionView
    }
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "AccountsScreenStrings")
        return localizer
    }()
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountsScreenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        setContent()
    }
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    private func didSelectAccount(_ account: Account) {
        updateAccountClosure?(account)
    }
    
    private func didDeleteAccount(_ account: Account, cellController: AUICollectionViewCellController) {
        deleteAccountClosure?(account)
        collectionViewController.deleteCellControllerAnimated(cellController, completion: nil)
    }
    
    private func didSelectAddAccount() {
        addAccountClosure?()
    }
    
    func addAccount(_ account: Account) {
        accounts.append(account)
        setCollectionViewControllerContent()
    }
    
    // MARK: Content
    
    private func setContent() {
        accountsScreenView.titleLabel.text = localizer.localizeText("screenTitle")
        setCollectionViewControllerContent()
    }
    
    private func setCollectionViewControllerContent() {
        collectionViewController.collectionView = accountsScreenView.collectionView
        accountsScreenView.collectionView.dragInteractionEnabled = true
        accountsScreenView.collectionView.dropDelegate = self
        accountsScreenView.collectionView.dragDelegate = self
        accountsScreenView.collectionView.reorderingCadence = .fast
        let sectionController = AUIEmptyCollectionViewSectionController()
        var cellControllers: [AUICollectionViewCellController] = []
        for account in accounts {
            let accountCellController = createAccountCollectionViewCellController(account: account)
            cellControllers.append(accountCellController)
        }
        let addAccountCellController = createAddAccountCollectionViewCellController()
        cellControllers.append(addAccountCellController)
        
        sectionController.cellControllers = cellControllers
        collectionViewController.sectionControllers = [sectionController]
    }
    
    private func createAccountCollectionViewCellController(account: Account) -> AccountCollectionViewCellController {
        let cellController = AccountCollectionViewCellController(account: account, localizer: localizer)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            let accountCollectionViewCell = self.accountsScreenView.accountCollectionViewCell(indexPath)
            return accountCollectionViewCell
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
        return cellController
    }
    
    private func createAddAccountCollectionViewCellController() -> AddAccountCollectionViewCellController {
        let cellController = AddAccountCollectionViewCellController(localizer: localizer)
        cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
            guard let self = self else { return UICollectionViewCell() }
            let accountCollectionViewCell = self.accountsScreenView.addAccountCollectionViewCell(indexPath)
            return accountCollectionViewCell
        }
        cellController.sizeForCellClosure = { [weak self] in
            guard let self = self else { return .zero }
            let size = self.accountsScreenView.addAccountCollectionViewCellSize()
            return size
        }
        cellController.didSelectClosure = { [weak self] in
            guard let self = self else { return }
            self.didSelectAddAccount()
        }
        return cellController
    }
    
    // MARK: UICollectionViewDropDelegate, UICollectionViewDragDelegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.item == accounts.count {
            return []
        }
        let string = "\(indexPath)"
        let provider = NSItemProvider(object: string as NSItemProviderWriting)
        provider.suggestedName = string
        let dragItem = UIDragItem(itemProvider: provider)
        return [dragItem]
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if destinationIndexPath == nil {
            return UICollectionViewDropProposal(operation: .forbidden, intent: .insertAtDestinationIndexPath)
        }
        if destinationIndexPath?.item == accounts.count {
            return UICollectionViewDropProposal(operation: .forbidden, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let sourceIndexPath = coordinator.items.first!.sourceIndexPath!
        let destinationIndexPath = coordinator.destinationIndexPath!
        collectionView.performBatchUpdates {
            let mo = self.collectionViewController.sectionControllers.first!.cellControllers.remove(at: sourceIndexPath.item)
            self.collectionViewController.sectionControllers.first!.cellControllers.insert(mo, at: destinationIndexPath.item)
            let ac = self.accounts.remove(at: sourceIndexPath.item)
            self.accounts.insert(ac, at: destinationIndexPath.item)
            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])
        } completion: { [weak self] finished in
            guard let self = self else { return }
            self.orderAccountsClosure?(self.accounts)
        }
        coordinator.drop(coordinator.items.first!.dragItem, toItemAt: coordinator.destinationIndexPath!)
    }
    
}
