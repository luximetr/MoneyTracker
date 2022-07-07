//
//  AddExpenceScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 12.03.2022.
//

import UIKit
import AUIKit

extension AddExpenseScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.inputDateView = InputDateView(appearance: appearance)
        self.commentTextField = PlainTextField(appearance: appearance)
        self.addButton = TextFilledButton(appearance: appearance)
        self.selectAccountView = BalanceAccountHorizontalPickerView(appearance: appearance)
        self.inputAmountView = InputAmountView(appearance: appearance)
        self.selectCategoryView = CategoryVerticalPickerView(appearance: appearance)
        self.errorSnackbarView = ErrorSnackbarView(appearance: appearance)
        super.init(appearance: appearance)
    }
    
    // MARK: - Subviews
    
    let inputDateView: InputDateView
    private let inputDateBackgroundView = PassthroughView()
    let inputDateLabel = UILabel()
    let dayExpensesLabel = UILabel()
    private let expensesTableViewContainerView = UIView()
    let expensesTableView = UITableView()
    private var expensTableViewCells: [ExpenseTableViewCell]? {
        let expenseTableViewCells = expensesTableView.visibleCells.compactMap({ $0 as? ExpenseTableViewCell })
        return expenseTableViewCells
    }
    let commentTextField: PlainTextField
    let addButton: TextFilledButton
    let selectAccountView: BalanceAccountHorizontalPickerView
    let inputAmountView: InputAmountView
    let selectCategoryView: CategoryVerticalPickerView
    let errorSnackbarView: ErrorSnackbarView
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        addSubview(inputDateView)
        addSubview(inputDateBackgroundView)
        addSubview(inputDateLabel)
        setupInputDateLabel()
        addSubview(dayExpensesLabel)
        setupDayExpensesLabel()
        addSubview(expensesTableViewContainerView)
        setupExpensesTableViewContainerView()
        expensesTableViewContainerView.addSubview(expensesTableView)
        setupExpenseTableView()
        setupExpenseTableViewCell()
        addSubview(commentTextField)
        addSubview(addButton)
        addSubview(selectAccountView)
        addSubview(inputAmountView)
        addSubview(selectCategoryView)
        addSubview(errorSnackbarView)
        bringSubviewToFront(navigationBarView)
        autoLayout()
        setAppearance(appearance)
    }
    
    private func setupInputDateLabel() {
        inputDateLabel.font = appearance.fonts.primary(size: 14, weight: .regular)
    }
    
    private func setupDayExpensesLabel() {
        dayExpensesLabel.font = appearance.fonts.primary(size: 14, weight: .bold)
        dayExpensesLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupExpensesTableViewContainerView() {
        expensesTableViewContainerView.layer.shadowOpacity = 1
        expensesTableViewContainerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    }
    
    private func setupExpenseTableView() {
        expensesTableView.backgroundColor = appearance.colors.primaryBackground
        expensesTableView.clipsToBounds = true
        expensesTableView.separatorStyle = .none
        expensesTableView.showsVerticalScrollIndicator = false
    }
    
    private let expenseTableViewCellReuseIdentifier = "expenseTableViewCellReuseIdentifier"
    private func setupExpenseTableViewCell() {
        expensesTableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: expenseTableViewCellReuseIdentifier)
    }
    
    // MARK: - AutoLayout
    
    private func autoLayout() {
        autoLayoutInputDateView()
    }
    
    private func autoLayoutInputDateView() {
        inputDateView.translatesAutoresizingMaskIntoConstraints = false
        inputDateView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        inputDateView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        inputDateView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor).isActive = true
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutInputAmountView()
        layoutAddButton()
        layoutSelectCategoryView()
        layoutDayExpensesLabel()
        layoutInputDateBackgroundView()
        layoutInputDateLabel()
        layoutSelectAccountView()
        layoutCommentTextField()
        layoutExpensesTableViewContainerView()
        layoutExpenseTableView()
        layoutErrorSnackbarView()
    }
    
    private func layoutInputDateBackgroundView() {
        let width = bounds.width - 16 * 2
        let height = CGFloat(50)
        let x = CGFloat(16)
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        inputDateBackgroundView.frame = frame
    }
    
    private func layoutInputDateLabel() {
        let width = (bounds.width - 16 * 2 - 10) * 0.3
        let height = inputDateLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude)).height
        let x = CGFloat(16)
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height + 17
        let frame = CGRect(x: x, y: y, width: width, height: height)
        inputDateLabel.frame = frame
    }
    
    private func layoutInputAmountView() {
        let width = (bounds.width - 16 * 2 - 10) * 0.6
        let height = inputAmountView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        let x = bounds.width - width - 16
        let y = bounds.height - 16 - height - safeAreaInsets.bottom
        let frame = CGRect(x: x, y: y, width: width, height: height)
        inputAmountView.frame = frame
    }
    
    private func layoutAddButton() {
        let x: CGFloat = 16
        let width = inputAmountView.frame.origin.x - 16 - 10
        let height: CGFloat = 44
        let y = bounds.height - 16 - height - safeAreaInsets.bottom
        let frame = CGRect(x: x, y: y, width: width, height: height)
        addButton.frame = frame
    }
    
    private func layoutSelectCategoryView() {
        let x: CGFloat = 16
        let width = addButton.frame.size.width
        let height = addButton.frame.origin.y - inputAmountView.frame.origin.y - 14
        let y: CGFloat = inputAmountView.frame.origin.y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        selectCategoryView.frame = frame
    }
    
    private func layoutSelectAccountView() {
        let x: CGFloat = 0
        let width = bounds.width
        let height: CGFloat = 26
        let y = inputAmountView.frame.origin.y - 14 - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        selectAccountView.frame = frame
        selectAccountView.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    private func layoutCommentTextField() {
        let x: CGFloat = 16
        let width = bounds.width - 2 * x
        let height: CGFloat = 44
        let y = selectAccountView.frame.origin.y - 14 - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        commentTextField.frame = frame
    }
    
    private func layoutDayExpensesLabel() {
        let x = inputDateView.frame.origin.x + inputDateView.frame.size.width
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let width = bounds.width - x - 16
        let height: CGFloat = 44
        let frame = CGRect(x: x, y: y, width: width, height: height)
        dayExpensesLabel.frame = frame
        dayExpensesLabel.textAlignment = .right
    }
    
    private func layoutExpensesTableViewContainerView() {
        let x: CGFloat = 16
        let width = bounds.width - 2 * x
        let y = inputDateView.frame.origin.y + inputDateView.frame.size.height + 8
        let height = commentTextField.frame.origin.y - inputDateView.frame.origin.y - inputDateView.frame.size.height - 14 - 8
        let frame = CGRect(x: x, y: y, width: width, height: height)
        expensesTableViewContainerView.frame = frame
        expensesTableViewContainerView.layer.shadowRadius = 4.0
        expensesTableViewContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        expensesTableViewContainerView.layer.cornerRadius = 10
    }
    
    private func layoutExpenseTableView() {
        expensesTableView.frame = expensesTableViewContainerView.bounds
        expensesTableView.layer.cornerRadius = 10
    }
    
    private func layoutErrorSnackbarView() {
        let x: CGFloat = 10
        let width = bounds.width - x * 2
        let availableSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let height: CGFloat = errorSnackbarView.sizeThatFits(availableSize).height
        let y = navigationBarView.frame.minY
        let frame = CGRect(x: x, y: y, width: width, height: height)
        errorSnackbarView.frame = frame
    }
    
    // MARK: - ExpensesTableView
    
    func expenseTableViewCell(_ indexPath: IndexPath) -> ExpenseTableViewCell {
        let expensesTableView = expensesTableView.dequeueReusableCell(withIdentifier: expenseTableViewCellReuseIdentifier, for: indexPath) as! ExpenseTableViewCell
        expensesTableView.setAppearance(appearance)
        return expensesTableView
    }
    
    func expenseTableViewCellEstimatedHeight() -> CGFloat {
        return 53
    }
    
    func expenseTableViewCellHeight() -> CGFloat {
        return 53
    }
    
    // MARK: - Appearance
    
    override func setAppearance(_ appearance: Appearance) {
        super.setAppearance(appearance)
        backgroundColor = appearance.colors.primaryBackground
        inputDateView.setAppearance(appearance)
        inputDateBackgroundView.backgroundColor = appearance.colors.primaryBackground
        inputDateLabel.textColor = appearance.colors.primaryText
        dayExpensesLabel.textColor = appearance.colors.primaryText
        expensesTableView.backgroundColor = appearance.colors.primaryBackground
        commentTextField.changeAppearance(appearance)
        expensTableViewCells?.forEach({ $0.setAppearance(appearance) })
        addButton.backgroundColor = appearance.colors.primaryActionBackground
        addButton.setTitleColor(appearance.colors.primaryActionText, for: .normal)
        inputAmountView.setAppearance(appearance)
        errorSnackbarView.setAppearance(appearance)
    }
    
}
}
