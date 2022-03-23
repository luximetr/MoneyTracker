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
    
    // MARK: Subviews
    
    let inputDateView = InputDateView()
    let dayExpensesLabel = UILabel()
    let expensesTableView = UITableView()
    let commentTextField: UITextField = CommentTextField()
    let addButton = PictureButton()
    let selectAccountView = BalanceAccountHorizontalPickerView()
    let inputAmountView = InputAmountView()
    let selectCategoryView = SelectCategoryView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.primaryBackground
        addSubview(inputDateView)
        addSubview(dayExpensesLabel)
        setupDayExpensesLabel()
        addSubview(expensesTableView)
        setupExpenseTableView()
        addSubview(commentTextField)
        addSubview(addButton)
        setupAddButton()
        addSubview(selectAccountView)
        addSubview(inputAmountView)
        addSubview(selectCategoryView)
        autoLayout()
    }
    
    private func setupDayExpensesLabel() {
        dayExpensesLabel.font = Fonts.default(size: 14, weight: .bold)
        dayExpensesLabel.textColor = Colors.primaryText
        dayExpensesLabel.adjustsFontSizeToFitWidth = true
    }
    
    private let expenseTableViewCellReuseIdentifier = "expenseTableViewCellReuseIdentifier"
    private func setupExpenseTableView() {
        expensesTableView.separatorStyle = .none
        expensesTableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: expenseTableViewCellReuseIdentifier)
    }
    
    private func setupAddButton() {
        addButton.backgroundColor = Colors.secondaryBackground
        addButton.setImage(Images.check.withRenderingMode(.alwaysTemplate), for: .normal)
        addButton.tintColor = Colors.secondaryText
    }
    
    // MARK: AutoLayout
    
    private func autoLayout() {
        autoLayoutInputDateView()
    }
    
    private func autoLayoutInputDateView() {
        inputDateView.translatesAutoresizingMaskIntoConstraints = false
        inputDateView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        inputDateView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        inputDateView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor).isActive = true
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutInputAmountView()
        layoutDayExpensesLabel()
        layoutSelectCategoryView()
        layoutSelectAccountView()
        layoutAddButton()
        layoutCommentTextField()
        layoutExpenseTableView()
    }
    
    private func layoutInputAmountView() {
        let width = (bounds.width - 16 * 2 - 5 * 2) / 2
        let height = inputAmountView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        let x = (bounds.width / 2) + 5
        let y = bounds.height - 16 - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        inputAmountView.frame = frame
    }
    
    private func layoutSelectCategoryView() {
        let width = (bounds.width - 16 * 2 - 5 * 2) / 2
        let height = inputAmountView.frame.size.height
        let x: CGFloat = 16
        let y = bounds.height - 16 - height
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
    
    private func layoutAddButton() {
        let width: CGFloat = 44
        let height = width
        let x = bounds.width - 16 - width
        let y = selectAccountView.frame.origin.y - 14 - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        addButton.frame = frame
        addButton.layer.cornerRadius = 10
    }
    
    private func layoutCommentTextField() {
        let width = addButton.frame.origin.x - 16 - 12
        let height: CGFloat = 44
        let x: CGFloat = 16
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
    
    private func layoutExpenseTableView() {
        let x: CGFloat = 0
        let width = bounds.width
        let y = inputDateView.frame.origin.y + inputDateView.frame.size.height
        let height = commentTextField.frame.origin.y - inputDateView.frame.origin.y - inputDateView.frame.size.height - 14
        let frame = CGRect(x: x, y: y, width: width, height: height)
        expensesTableView.frame = frame
    }
    
    // MARK: ExpensesTableView
    
    func expenseTableViewCell(_ indexPath: IndexPath) -> ExpenseTableViewCell {
        let cell = expensesTableView.dequeueReusableCell(withIdentifier: expenseTableViewCellReuseIdentifier, for: indexPath) as! ExpenseTableViewCell
        return cell
    }
    
    func expenseTableViewCellEstimatedHeight() -> CGFloat {
        return 53
    }
    
    func expenseTableViewCellHeight() -> CGFloat {
        return 53
    }
    
}
}
