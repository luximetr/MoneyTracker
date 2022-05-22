//
//  BalanceCalculatorScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 22.05.2022.
//

import UIKit
import AUIKit

final class BalanceCalculatorScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Data
    
    private var accounts: [Account]
    private var selectedAccounts: [Account]
    
    // MARK: - Initializer
    
    init(appearance: Appearance, locale: Locale, accounts: [Account]) {
        self.accounts = accounts
        self.selectedAccounts = accounts
        super.init(appearance: appearance, locale: locale)
    }
    
    // MARK: - Delegation
    
    var backClosure: (() -> Void)?
    
    // MARK: - View
    
    override func loadView() {
        view = ScreenView(appearance: appearance)
    }
    
    private var screenView: ScreenView {
        return view as! ScreenView
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
    
    // MARK: - Components
    
    private let collectionViewController = AUIEmptyCollectionViewController()
    private let accountsSectionController = AUIEmptyCollectionViewSectionController()
    private var accountsCellControllers: [AccountCollectionViewCellController] {
        return accountsSectionController.cellControllers.compactMap { $0 as? AccountCollectionViewCellController }
    }
    private func accountsCellController(_ account: Account) -> AccountCollectionViewCellController? {
        return accountsCellControllers.first(where: { $0.account.id == account.id })
    }
    
    // MARK: - Localizer
    
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
        let cellConroller = accountsCellController(account)
        if let firstIndex = selectedAccounts.firstIndex(of: account) {
            selectedAccounts.remove(at: firstIndex)
            cellConroller?.setIsSelected(false)
        } else {
            selectedAccounts.append(account)
            cellConroller?.setIsSelected(true)
        }
        setBalanceLabelContent()
    }
    
    private func didDeleteAccount(_ account: Account, cellController: AUICollectionViewCellController) {
        //deleteAccountClosure?(account)
        //collectionViewController.deleteCellController(cellController, completion: nil)
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
        setBalanceLabelContent()
        setCollectionViewControllerContent()
    }
    
    private func setBalanceLabelContent() {
//        let currenciesAmounts = Dictionary(grouping: expenses, by: { $0.account.currency })
//        let gg = Dictionary(uniqueKeysWithValues: currenciesAmounts.map({ ($0, $1.map({ $0.amount }).reduce(into: Decimal(), +)) }))
        var currenciesAmount: [Currency: Decimal] = [:]
        for account in selectedAccounts {
            let currency = account.currency
            let amount = account.amount
            let currencyAmount = (currenciesAmount[currency] ?? .zero) + amount
            currenciesAmount[currency] = currencyAmount
        }
        var currenciesAmountsStrings: [String] = []
        let sortedCurrencyAmount = currenciesAmount.sorted(by: { $0.1 > $1.1 })
        for (currency, amount) in sortedCurrencyAmount {
            let currencyAmountString = "\(amount) \(currency.rawValue.uppercased())"
            currenciesAmountsStrings.append(currencyAmountString)
        }
        let currenciesAmountsStringsJoined = currenciesAmountsStrings.joined(separator: " + ")
        screenView.balanceLabel.text = currenciesAmountsStringsJoined
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
        let isSelected = selectedAccounts.contains(account)
        let cellController = AccountCollectionViewCellController(account: account, appearance: appearance, isSelected: isSelected)
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
    
}
