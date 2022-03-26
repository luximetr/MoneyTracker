//
//  AddCategoryScreenView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.02.2022.
//

import UIKit
import AUIKit

extension AddCategoryScreenViewController {
final class ScreenView: BackTitleNavigationBarScreenView {
    
    // MARK: Subviews
    
    let scrollView = UIScrollView()
    let nameTextField: UITextField = TextField()
    let addButton = TextFilledButton()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.white
        addSubview(scrollView)
        scrollView.addSubview(nameTextField)
        addSubview(addButton)
        setupNameTextField()
    }
    
    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = Colors.white
    }
    
    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = Colors.white
    }
    
    private func setupNameTextField() {
        
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutScrollView()
        layoutNameTextField()
        layoutAddButton()
        setScrollViewContentSize()
    }
    
    private func layoutScrollView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.size.height
        let width = bounds.width
        let height = bounds.height - y
        var frame = CGRect(x: x, y: y, width: width, height: height)
        if let keyboardFrame = keyboardFrame {
            frame.size.height -= keyboardFrame.size.height
        }
        scrollView.frame = frame
    }
    
    private func layoutNameTextField() {
        let x: CGFloat = 16
        let y: CGFloat = 32
        let width = bounds.width - 2 * x
        let height: CGFloat = 44
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nameTextField.frame = frame
    }
    
    private func setScrollViewContentSize() {
        let width = scrollView.bounds.width
        let height = nameTextField.frame.origin.y + nameTextField.frame.size.height + 16.0 + safeAreaInsets.bottom
        let contentSize = CGSize(width: width, height: height)
        scrollView.contentSize = contentSize
    }
    
    private func layoutAddButton() {
        let x: CGFloat = 44
        let width = bounds.width - 2 * x
        let height: CGFloat = 44
        let y = bounds.height - 16 - height - safeAreaInsets.bottom
        var frame = CGRect(x: x, y: y, width: width, height: height)
        if let keyboardFrame = keyboardFrame {
            frame.origin.y -= keyboardFrame.size.height
        }
        addButton.frame = frame
    }
    
    // MARK: Keyboard
    
    private var keyboardFrame: CGRect?
    
    func setKeyboardFrame(_ keyboardFrame: CGRect?) {
        self.keyboardFrame = keyboardFrame
        setNeedsLayout()
        layoutIfNeeded()
    }
    
}

private final class TextField: AUITextField {
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.gray
        layer.cornerRadius = 10
    }
    
    // MARK: Layout
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var editingRect = super.editingRect(forBounds: bounds)
        editingRect.origin.x += 16
        editingRect.size.width -= 32
        return editingRect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.editingRect(forBounds: bounds)
        textRect.origin.x += 16
        textRect.size.width -= 32
        return textRect
    }
}
}
