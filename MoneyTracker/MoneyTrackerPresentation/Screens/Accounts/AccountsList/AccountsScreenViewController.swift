//
//  AccountsScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 08.02.2022.
//

import UIKit
import AUIKit

final class AccountsScreenViewController: StatusBarScreenViewController, UICollectionViewDropDelegate, UICollectionViewDragDelegate {
    
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
        screenView.addButton.addTarget(self, action: #selector(addButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupCollectionViewController()
        setContent()
    }
    
    private func setupCollectionViewController() {
        collectionViewController.collectionView = screenView.collectionView
        screenView.collectionView.dragInteractionEnabled = true
        screenView.collectionView.dropDelegate = self
        screenView.collectionView.dragDelegate = self
    }
    
    // MARK: Subcomponents
    
    private let collectionViewController = AUIEmptyCollectionViewController()
    private let accountsSectionController = AUIEmptyCollectionViewSectionController()
    private let addAccountSectionController = AUIEmptyCollectionViewSectionController()
    
    // MARK: Localizer
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "AccountsScreenStrings")
        return localizer
    }()
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        setContent()
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        screenView.changeAppearance(appearance)
        accountsCellControllers.forEach { $0.setAppearance(appearance) }
    }
    
    // MARK: Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    @objc private func addButtonTouchUpInsideEventAction() {
        addAccountClosure?()
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
        screenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
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
        let cellController = AccountCollectionViewCellController(account: account, localizer: localizer, appearance: appearance)
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
        cellController.didDeleteClosure = { [weak self] in
            guard let self = self else { return }
            self.didDeleteAccount(account, cellController: cellController)
        }
        return cellController
    }
    
    private var accountsCellControllers: [AccountCollectionViewCellController] {
        return accountsSectionController.cellControllers.compactMap { $0 as? AccountCollectionViewCellController }
    }
    
    // MARK: UICollectionViewDropDelegate, UICollectionViewDragDelegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.section == 1 {
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
            return UICollectionViewDropProposal(operation: .cancel, intent: .insertAtDestinationIndexPath)
        }
        if destinationIndexPath?.section == 1 {
            return UICollectionViewDropProposal(operation: .cancel, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let sourceIndexPath = coordinator.items.first!.sourceIndexPath!
        let destinationIndexPath = coordinator.destinationIndexPath!
        let mo = collectionViewController.sectionControllers.first!.cellControllers.remove(at: sourceIndexPath.item)
        collectionViewController.sectionControllers.first!.cellControllers.insert(mo, at: destinationIndexPath.item)
        let ac = accounts.remove(at: sourceIndexPath.item)
        accounts.insert(ac, at: destinationIndexPath.item)
        collectionViewController.movedIndexPath = sourceIndexPath
        collectionViewController.moveItem(at: sourceIndexPath, to: destinationIndexPath) { [weak self] finished in
            guard let self = self else { return }
            self.orderAccountsClosure?(self.accounts)
        }
        coordinator.drop(coordinator.items.first!.dragItem, toItemAt: coordinator.destinationIndexPath!)
    }
    
}
