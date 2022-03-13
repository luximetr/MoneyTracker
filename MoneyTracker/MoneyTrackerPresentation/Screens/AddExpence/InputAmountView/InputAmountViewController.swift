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
    
    // MARK: Input
    
    var input: String = "" {
        didSet {
            didSetInput(oldValue)
        }
    }
    func didSetInput(_ oldValue: String) {
        inputAmountView?.inputLabel.text = input
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
        inputAmountView?.sevenKeyButton.addTarget(self, action: #selector(sevenKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.sevenKeyButton.setTitle("7", for: .normal)
        inputAmountView?.eightKeyButton.addTarget(self, action: #selector(eightKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.eightKeyButton.setTitle("8", for: .normal)
        inputAmountView?.nineKeyButton.addTarget(self, action: #selector(nineKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.nineKeyButton.setTitle("9", for: .normal)
        inputAmountView?.fourKeyButton.addTarget(self, action: #selector(fourKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.fourKeyButton.setTitle("4", for: .normal)
        inputAmountView?.fiveKeyButton.addTarget(self, action: #selector(fiveKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.fiveKeyButton.setTitle("5", for: .normal)
        inputAmountView?.sixKeyButton.addTarget(self, action: #selector(sixKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.sixKeyButton.setTitle("6", for: .normal)
        inputAmountView?.oneKeyButton.addTarget(self, action: #selector(oneKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.oneKeyButton.setTitle("1", for: .normal)
        inputAmountView?.twoKeyButton.addTarget(self, action: #selector(twoKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.twoKeyButton.setTitle("2", for: .normal)
        inputAmountView?.threeKeyButton.addTarget(self, action: #selector(threeKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.threeKeyButton.setTitle("3", for: .normal)
        inputAmountView?.decimalSeparatorKeyButton.addTarget(self, action: #selector(decimalSeparatorKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.decimalSeparatorKeyButton.setTitle(".", for: .normal)
        inputAmountView?.zeroKeyButton.addTarget(self, action: #selector(zeroKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.zeroKeyButton.setTitle("0", for: .normal)
        inputAmountView?.deleteKeyButton.addTarget(self, action: #selector(deleteKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.deleteKeyButton.setTitle("⌫", for: .normal)
    }

    override func unsetupView() {
        super.unsetupView()
        unsetupInputAmountView()
    }
  
    func unsetupInputAmountView() {
        inputAmountView?.sevenKeyButton.removeTarget(self, action: #selector(sevenKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.eightKeyButton.removeTarget(self, action: #selector(eightKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.nineKeyButton.removeTarget(self, action: #selector(nineKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.fourKeyButton.removeTarget(self, action: #selector(fourKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.fiveKeyButton.removeTarget(self, action: #selector(fiveKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.sixKeyButton.removeTarget(self, action: #selector(sixKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.oneKeyButton.removeTarget(self, action: #selector(oneKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.twoKeyButton.removeTarget(self, action: #selector(twoKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.threeKeyButton.removeTarget(self, action: #selector(threeKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.decimalSeparatorKeyButton.removeTarget(self, action: #selector(decimalSeparatorKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.zeroKeyButton.removeTarget(self, action: #selector(zeroKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
        inputAmountView?.deleteKeyButton.removeTarget(self, action: #selector(deleteKeyButtonTouchUpInsideEventAction), for: .touchUpInside)
    }
    
    // MARK: Actions
    
    @objc func sevenKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("7")
    }
    
    @objc func eightKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("8")
    }
    
    @objc func nineKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("9")
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
    
    @objc func oneKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("1")
    }
    
    @objc func twoKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("2")
    }
    
    @objc func threeKeyButtonTouchUpInsideEventAction() {
        tryToAddDigit("3")
    }
    
    @objc func decimalSeparatorKeyButtonTouchUpInsideEventAction() {
        tryToAddDecimalSeparator()
    }
    
    @objc func zeroKeyButtonTouchUpInsideEventAction() {
        tryToAddDigitZero()
    }
    
    @objc func deleteKeyButtonTouchUpInsideEventAction() {
        tryToDelete()
    }
    
    private func tryToAddDigit(_ digit: String) {
        guard !input.starts(with: "0") || input.starts(with: "0.") else { return }
        let parts = input.split(separator: ".")
        if parts.count == 2, let fractionPart = parts.last {
            if fractionPart.count < 2 {
                input += digit
            }
        } else {
            input += digit
        }
    }
    
    private func tryToAddDecimalSeparator() {
        guard !input.isEmpty else { return }
        guard !input.contains(".") else { return }
        input += "."
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
