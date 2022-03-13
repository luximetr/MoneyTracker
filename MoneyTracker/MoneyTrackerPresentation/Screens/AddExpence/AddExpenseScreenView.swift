//
//  AddExpenceScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 12.03.2022.
//

import UIKit
import AUIKit

final class AddExpenseScreenView: TitleNavigationBarScreenView {
    
    // MARK: Subviews
    
    let inputDateView = InputDateView()
    let tableView = UITableView()
    let commentTextField: UITextField = CommentTextField()
    let addButton: UIButton = TextFilledButton()
    let selectAccountView = UIView()
    let inputAmountView = InputAmountView()
    let selectCategoryView = SelectCategoryView()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.primaryBackground
        addSubview(inputDateView)
        setupInputDateView()
        addSubview(tableView)
        setupTableView()
        addSubview(commentTextField)
        setupCommentTextField()
        addSubview(addButton)
        setupAddButton()
        addSubview(selectAccountView)
        addSubview(inputAmountView)
        addSubview(selectCategoryView)
    }
    
    private func setupInputDateView() {
        
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors.secondaryBackground
    }
    
    private func setupCommentTextField() {
        commentTextField.backgroundColor = Colors.secondaryBackground
    }
    
    private func setupAddButton() {
        addButton.backgroundColor = Colors.secondaryBackground
        addButton.setTitleColor(Colors.primaryText, for: .normal)
        addButton.titleLabel?.font = Fonts.default(size: 26, weight: .regular)
        addButton.clipsToBounds = true
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutInputAmountView()
        layoutSelectCategoryView()
        layoutSelectAccountView()
        layoutAddButton()
        layoutCommentTextField()
        layoutInputDateView()
        layoutTableView()
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
        let x: CGFloat = 16
        let width = bounds.width - 2 * x
        let height: CGFloat = 26
        let y = inputAmountView.frame.origin.y - 14 - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        selectAccountView.frame = frame
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
    
    private func layoutInputDateView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let width = bounds.width
        let height: CGFloat = 44
        let frame = CGRect(x: x, y: y, width: width, height: height)
        inputDateView.frame = frame
    }
    
    private func layoutTableView() {
        let x: CGFloat = 0
        let width = bounds.width
        let y = inputDateView.frame.origin.y + inputDateView.frame.size.height
        let height = commentTextField.frame.origin.y - inputDateView.frame.origin.y - inputDateView.frame.size.height - 14
        let frame = CGRect(x: x, y: y, width: width, height: height)
        tableView.frame = frame
    }
    
}

private final class CommentTextField: AUITextField {
    
    // MARK: Placeholder
    
    override var placeholder: String? {
        get {
            return attributedPlaceholder?.string
        }
        set {
            guard let string = newValue else { return }
            let attributes: [NSAttributedString.Key : Any] = [
                .font: Fonts.default(size: 17, weight: .regular),
                .foregroundColor: Colors.secondaryText
            ]
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            attributedPlaceholder = attributedString
        }
    }
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        clipsToBounds = true
        tintColor = Colors.primaryText
        textColor = Colors.primaryText
        font = Fonts.default(size: 17, weight: .regular)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.x = 16
        textRect.size.width -= 16 * 2
        return textRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var editingRect = super.editingRect(forBounds: bounds)
        editingRect.origin.x = 16
        editingRect.size.width -= 16 * 2
        return editingRect
    }
    
}
