//
//  InputAmountViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 12.03.2022.
//

import UIKit
import AUIKit

extension AddExpenseScreenViewController {
final class InputAmountViewController: AUIEmptyViewController {
    
    // MARK: Amount
    
    var amount: Decimal? {
        let amountNumber = amountNumberFormatter.number(from: input)
        let amount = amountNumber?.decimalValue
        return amount
    }
    
    lazy var amountNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        return numberFormatter
    }()
    
    // MARK: Placeholder
    
    var placeholder: String = "" {
        didSet {
            didSetPlaceholder(oldValue)
        }
    }
    
    private func didSetPlaceholder(_ oldValue: String) {
        inputAmountView?.placeholderLabel.text = placeholder
    }
    
    // MARK: - Placeholder - Is visible
    
    private var isPlaceholderVisible: Bool = true {
        didSet {
            didSetIsPlaceholderVisible(oldValue)
        }
    }
    
    private func didSetIsPlaceholderVisible(_ oldValue: Bool) {
        inputAmountView?.placeholderLabel.isHidden = !isPlaceholderVisible
        inputAmountView?.inputLabel.isHidden = isPlaceholderVisible
    }
    
    // MARK: Input
    
    var input: String = "" {
        didSet {
            didSetInput(oldValue)
        }
    }
    func didSetInput(_ oldValue: String) {
        inputAmountView?.inputLabel.text = input
        isPlaceholderVisible = input.isEmpty
    }
    
    // MARK: InputAmountView
  
    var inputAmountView: InputAmountView? {
        set { view = newValue }
        get { return view as? InputAmountView }
    }
  
    override func setupView() {
        super.setupView()
        setupInputAmountView()
    }
    
    func setupInputAmountView() {
        inputAmountView?.deleteKeyButton.addTarget(self, action: #selector(deleteKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.deleteKeyButton.setTitle("⌫", for: .normal)
        inputAmountView?.sevenKeyButton.addTarget(self, action: #selector(sevenKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.sevenKeyButton.setTitle("7", for: .normal)
        inputAmountView?.eightKeyButton.addTarget(self, action: #selector(eightKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.eightKeyButton.setTitle("8", for: .normal)
        inputAmountView?.nineKeyButton.addTarget(self, action: #selector(nineKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.nineKeyButton.setTitle("9", for: .normal)
        inputAmountView?.divisionKeyButton.addTarget(self, action: #selector(divisionKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.divisionKeyButton.setTitle("/", for: .normal)
        inputAmountView?.fourKeyButton.addTarget(self, action: #selector(fourKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.fourKeyButton.setTitle("4", for: .normal)
        inputAmountView?.fiveKeyButton.addTarget(self, action: #selector(fiveKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.fiveKeyButton.setTitle("5", for: .normal)
        inputAmountView?.sixKeyButton.addTarget(self, action: #selector(sixKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.sixKeyButton.setTitle("6", for: .normal)
        inputAmountView?.multiplicationKeyButton.addTarget(self, action: #selector(multiplicationKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.multiplicationKeyButton.setTitle("*", for: .normal)
        inputAmountView?.oneKeyButton.addTarget(self, action: #selector(oneKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.oneKeyButton.setTitle("1", for: .normal)
        inputAmountView?.twoKeyButton.addTarget(self, action: #selector(twoKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.twoKeyButton.setTitle("2", for: .normal)
        inputAmountView?.threeKeyButton.addTarget(self, action: #selector(threeKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.threeKeyButton.setTitle("3", for: .normal)
        inputAmountView?.subtractionKeyButton.addTarget(self, action: #selector(subtractionKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.subtractionKeyButton.setTitle("-", for: .normal)
        inputAmountView?.decimalSeparatorKeyButton.addTarget(self, action: #selector(decimalSeparatorKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.decimalSeparatorKeyButton.setTitle(".", for: .normal)
        inputAmountView?.zeroKeyButton.addTarget(self, action: #selector(zeroKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.zeroKeyButton.setTitle("0", for: .normal)
        inputAmountView?.calculateKeyButton.addTarget(self, action: #selector(calculateKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.calculateKeyButton.setTitle("=", for: .normal)
        inputAmountView?.additionKeyButton.addTarget(self, action: #selector(additionKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.additionKeyButton.setTitle("+", for: .normal)
    }

    override func unsetupView() {
        super.unsetupView()
        unsetupInputAmountView()
    }
  
    func unsetupInputAmountView() {
        inputAmountView?.deleteKeyButton.removeTarget(self, action: #selector(deleteKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.sevenKeyButton.removeTarget(self, action: #selector(sevenKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.eightKeyButton.removeTarget(self, action: #selector(eightKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.nineKeyButton.removeTarget(self, action: #selector(nineKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.divisionKeyButton.removeTarget(self, action: #selector(divisionKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.fourKeyButton.removeTarget(self, action: #selector(fourKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.fiveKeyButton.removeTarget(self, action: #selector(fiveKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.sixKeyButton.removeTarget(self, action: #selector(sixKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.multiplicationKeyButton.removeTarget(self, action: #selector(multiplicationKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.oneKeyButton.removeTarget(self, action: #selector(oneKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.twoKeyButton.removeTarget(self, action: #selector(twoKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.threeKeyButton.removeTarget(self, action: #selector(threeKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.subtractionKeyButton.removeTarget(self, action: #selector(subtractionKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.decimalSeparatorKeyButton.removeTarget(self, action: #selector(decimalSeparatorKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.zeroKeyButton.removeTarget(self, action: #selector(zeroKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.calculateKeyButton.removeTarget(self, action: #selector(deleteKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.additionKeyButton.removeTarget(self, action: #selector(additionKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
    }
    
    // MARK: Events
    
    @objc func sevenKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("7")
    }
    
    @objc func eightKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("8")
    }
    
    @objc func nineKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("9")
    }
    
    @objc func divisionKeyButtonTouchUpInsideEventAction() {
        tryToAddOperation("/")
    }
    
    @objc func fourKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("4")
    }
    
    @objc func fiveKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("5")
    }
    
    @objc func sixKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("6")
    }
    
    @objc func multiplicationKeyButtonTouchUpInsideEventAction() {
        tryToAddOperation("*")
    }
    
    @objc func oneKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("1")
    }
    
    @objc func twoKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("2")
    }
    
    @objc func threeKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("3")
    }
    
    @objc func subtractionKeyButtonTouchUpInsideEventAction() {
        tryToAddOperation("-")
    }
    
    @objc func decimalSeparatorKeyButtonTouchUpInsideEventAction() {
        tryToAddDecimalSeparator()
    }
    
    @objc func zeroKeyButtonTouchUpInsideEventAction() {
        tryToAddDigitZero()
    }
    
    @objc func calculateKeyButtonTouchUpInsideEventAction() {
        tryToCalculate()
    }
    
    @objc func additionKeyButtonTouchUpInsideEventAction() {
        tryToAddOperation("+")
    }
    
    @objc func deleteKeyButtonTouchUpInsideEventAction() {
        tryToDelete()
    }
    
    // MARK: Content
    
    private var operation: String? {
        if input.contains("+") {
            return "+"
        } else if input.contains("-") {
            return "-"
        } else if input.contains("/") {
            return "/"
        } else if input.contains("*") {
            return "*"
        } else {
            return nil
        }
    }
    
    private var leftNumber: Decimal? {
        if let operation = operation {
            if let leftNumberInput = input.components(separatedBy: operation).first {
                let leftNumber = amountNumberFormatter.number(from: leftNumberInput)
                return leftNumber?.decimalValue
            } else {
                return nil
            }
        } else {
            let leftNumber = amountNumberFormatter.number(from: input)
            return leftNumber?.decimalValue
        }
    }
    
    private var rightNumberInput: String? {
        if let operation = operation {
            let leftNumberInput = input.components(separatedBy: operation).last
            return leftNumberInput
        } else {
            return nil
        }
    }
    
    private var rightNumber: Decimal? {
        if let operation = operation {
            if let leftNumberInput = input.components(separatedBy: operation).last {
                let leftNumber = amountNumberFormatter.number(from: leftNumberInput)
                return leftNumber?.decimalValue
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    @discardableResult
    private func tryToCalculate() -> Bool {
        guard let operation = operation else { return false }
        guard let leftNumber = leftNumber else { return false }
        guard let rightNumber = rightNumber else { return false }
        if operation == "+" {
            input = "\(leftNumber + rightNumber)"
            return true
        } else if operation == "-" {
            input = "\(leftNumber - rightNumber)"
            return true
        } else if operation == "*" {
            input = "\(leftNumber * rightNumber)"
            return true
        } else if operation == "/" {
            input = "\(leftNumber / rightNumber)"
            return true
        } else {
            return false
        }
    }
    
    private func tryToAddOperation(_ operation: String) {
        if self.operation != nil {
            if tryToCalculate() {
                guard amountNumberFormatter.number(from: input) != nil else { return }
                guard !input.hasSuffix(".") else { return }
                input += operation
            }
        } else {
            guard amountNumberFormatter.number(from: input) != nil else { return }
            guard !input.hasSuffix(".") else { return }
            input += operation
        }
    }
    
    private func tryToAddDigit(_ digit: String) {
        let input = rightNumberInput ?? self.input
        guard !input.starts(with: "0") || input.starts(with: "0.") else { return }
        let parts = input.split(separator: ".")
        if parts.count == 2, let fractionPart = parts.last {
            if fractionPart.count < 2 {
                self.input += digit
            }
        } else {
            self.input += digit
        }
    }
    
    private func tryToAddDecimalSeparator() {
        let input = rightNumberInput ?? self.input
        guard !input.isEmpty else { return }
        guard !input.contains(".") else { return }
        guard !input.contains("+") else { return }
        guard !input.contains("-") else { return }
        guard !input.contains("/") else { return }
        guard !input.contains("*") else { return }
        self.input += "."
    }
    
    private func tryToAddDigitZero() {
        guard !input.starts(with: "0") else {
            if input == "0." {
                input += "0"
            }
            return
        }
        let parts = input.split(separator: ".")
        if parts.count == 2, let fractionPart = parts.last {
            if fractionPart.count < 2 {
                input += "0"
            }
        } else {
            input += "0"
        }
    }
    
    private func tryToDelete() {
        if !input.isEmpty {
            input = String(input.dropLast())
        }
    }
    
}
}
