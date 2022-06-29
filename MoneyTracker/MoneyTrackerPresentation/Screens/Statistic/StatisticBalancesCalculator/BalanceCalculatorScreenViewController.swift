//
//  BalanceCalculatorScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 22.05.2022.
//

import UIKit
import AUIKit
import AFoundation

final class BalanceCalculatorScreenViewController: StatusBarScreenViewController {
    
    // MARK: - Data
    
    private var accounts: [Account]
    private var selectedAccounts: [Account]
    private var accountsBalance: CurrenciesAmount?
    var accountsBalanceClosure: (([Account], @escaping (Result<CurrenciesAmount, Swift.Error>) -> Void) -> Void)?
    
    private func loadAccountsBalance() {
        self.accountsBalanceClosure?(selectedAccounts, { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let accountsBalance):
                self.accountsBalance = accountsBalance
                self.setBalanceLabelContent()
            case .failure:
                break
            }
        })
    }
    
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
    
    private let collectionViewController = AUIEmptyCollectionViewController()
    private let accountsSectionController = AUIEmptyCollectionViewSectionController()
    private var accountsCellControllers: [AccountCollectionViewCellController] {
        return accountsSectionController.cellControllers.compactMap { $0 as? AccountCollectionViewCellController }
    }
    private func accountsCellController(_ account: Account) -> AccountCollectionViewCellController? {
        return accountsCellControllers.first(where: { $0.account.id == account.id })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.backButton.addTarget(self, action: #selector(backButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.resetButton.addTarget(self, action: #selector(resetButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.allButton.addTarget(self, action: #selector(allButtonTouchUpInsideEventAction), for: .touchUpInside)
        collectionViewController.collectionView = screenView.collectionView
        setContent()
        setupReselAllButtons()
        loadAccountsBalance()
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        screenView.setAppearance(appearance)
        accountsCellControllers.forEach { $0.setAppearance(appearance) }
    }
    
    // MARK: - Localization
    
    private lazy var localizer: Localizer = {
        let localizer = Localizer(locale: locale, stringsTableName: "BalanceCalculatorScreenStrings")
        return localizer
    }()
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        fundsAmountNumberFormatter.locale = locale.foundationLocale
        setContent()
    }
    
    // MARK: Content
    
    private lazy var fundsAmountNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale.foundationLocale
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    private func setContent() {
        screenView.titleLabel.text = localizer.localizeText("screenTitle")
        screenView.resetButton.setTitle(localizer.localizeText("reset"), for: .normal)
        screenView.allButton.setTitle(localizer.localizeText("all"), for: .normal)
        setBalanceLabelContent()
        setCollectionViewControllerContent()
    }
    
    private func setBalanceLabelContent() {
        guard let accountsBalance = accountsBalance else { return }
        let currenciesAmount: [Currency: Decimal] = accountsBalance.currenciesAmount
        var currenciesAmountsStrings: [String] = []
        let sortedCurrencyAmount = currenciesAmount.sorted(by: { $0.1 > $1.1 })
        for (currency, amount) in sortedCurrencyAmount {
            let fundsString = fundsAmountNumberFormatter.string(amount)
            let currencyAmountString = "\(fundsString) \(currency.rawValue.uppercased())"
            currenciesAmountsStrings.append(currencyAmountString)
        }
        let currenciesAmountsStringsJoined = currenciesAmountsStrings.joined(separator: " + ")
        screenView.setBalance(currenciesAmountsStringsJoined)
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
        let cellController = AccountCollectionViewCellController(account: account, appearance: appearance, isSelected: isSelected, fundsAmountNumberFormatter: fundsAmountNumberFormatter)
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
        cellController.didSelectClosure = { [weak self, weak cellController] in
            guard let self = self else { return }
            guard let cellController = cellController else { return }
            self.didSelectAccount(cellController.account)
        }
        return cellController
    }
    
    // MARK: Events
    
    @objc private func backButtonTouchUpInsideEventAction() {
        backClosure?()
    }
    
    @objc private func resetButtonTouchUpInsideEventAction() {
        selectedAccounts = []
        accountsCellControllers.forEach({ $0.setIsSelected(false) })
        loadAccountsBalance()
        setupReselAllButtons()
    }
    
    @objc private func allButtonTouchUpInsideEventAction() {
        selectedAccounts = accounts
        accountsCellControllers.forEach({ $0.setIsSelected(true) })
        loadAccountsBalance()
        setupReselAllButtons()
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
        loadAccountsBalance()
        setupReselAllButtons()
    }
    
    func setupReselAllButtons() {
        if selectedAccounts.isEmpty {
            screenView.resetButton.isHidden = true
            screenView.allButton.isHidden = false
        } else {
            screenView.resetButton.isHidden = false
            screenView.allButton.isHidden = true
        }
    }
    
}
