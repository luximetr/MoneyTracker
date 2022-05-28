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
        screenView.resetButton.addTarget(self, action: #selector(resetButtonTouchUpInsideEventAction), for: .touchUpInside)
        screenView.allButton.addTarget(self, action: #selector(allButtonTouchUpInsideEventAction), for: .touchUpInside)
        setupCollectionViewController()
        setContent()
        setupReselAllButtons()
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
    
    override func setLocale(_ locale: Locale) {
        super.setLocale(locale)
        fundsAmountNumberFormatter.locale = locale.foundationLocale
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
    
    @objc private func resetButtonTouchUpInsideEventAction() {
        selectedAccounts = []
        accountsCellControllers.forEach({ $0.setIsSelected(false) })
        setBalanceLabelContent()
        setupReselAllButtons()
    }
    
    @objc private func allButtonTouchUpInsideEventAction() {
        selectedAccounts = accounts
        accountsCellControllers.forEach({ $0.setIsSelected(true) })
        setBalanceLabelContent()
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
        setBalanceLabelContent()
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
        var currenciesAmount: [Currency: Decimal] = [:]
        for account in accounts {
            let currency = account.currency
            let currencyAmount = Decimal()
            currenciesAmount[currency] = currencyAmount
        }
        for account in selectedAccounts {
            let currency = account.currency
            let amount = account.amount
            let currencyAmount = (currenciesAmount[currency] ?? .zero) + amount
            currenciesAmount[currency] = currencyAmount
        }
        var currenciesAmountsStrings: [String] = []
        let sortedCurrencyAmount = currenciesAmount.sorted(by: { $0.1 > $1.1 })
        for (currency, amount) in sortedCurrencyAmount {
            let fundsString = fundsAmountNumberFormatter.string(from: amount as NSNumber) ?? ""
            let currencyAmountString = "\(fundsString) \(currency.rawValue.uppercased())"
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
    
}
