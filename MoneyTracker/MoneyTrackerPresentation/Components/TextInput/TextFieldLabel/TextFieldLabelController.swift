//
//  TextFieldLabelController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 18.03.2022.
//

import UIKit
import AUIKit

protocol TextFieldLabelView {
    var textFieldLabelViewTextField: UITextField { get }
    var textFieldLabelViewLabel: UILabel { get }
}

class TextFieldLabelController: AUIEmptyViewController {
    
    // MARK: - View
    
    var textFieldLabelView: TextFieldLabelView? {
        set { view = newValue as? UIView }
        get { return view as? TextFieldLabelView }
    }
    
    override func setupView() {
        super.setupView()
        textFieldController.textField = textFieldLabelView?.textFieldLabelViewTextField
        labelController.label = textFieldLabelView?.textFieldLabelViewLabel
    }
    
    override func unsetupView() {
        super.unsetupView()
        textFieldController.textField = nil
        labelController.label = nil
    }
    
    // MARK: - Controllers
    
    let textFieldController = AUIEmptyTextFieldController()
    let labelController = AUIEmptyLabelController()
    
    
}
