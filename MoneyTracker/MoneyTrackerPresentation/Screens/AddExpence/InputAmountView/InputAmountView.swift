//
//  InputAmountView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 12.03.2022.
//

import UIKit
import AUIKit

extension AddExpenseScreenViewController {
final class InputAmountView: AUIView {
    
    // MARK: Subviews
    
    let inputLabel = UILabel()
    let separatorView = UIView()
    let deleteKeyButton = OperationKeyButton()
    let sevenKeyButton = KeyButton()
    let eightKeyButton = KeyButton()
    let nineKeyButton = KeyButton()
    let divisionKeyButton = OperationKeyButton()
    let fourKeyButton = KeyButton()
    let fiveKeyButton = KeyButton()
    let sixKeyButton = KeyButton()
    let multiplicationKeyButton = OperationKeyButton()
    let oneKeyButton = KeyButton()
    let twoKeyButton = KeyButton()
    let threeKeyButton = KeyButton()
    let subtractionKeyButton = OperationKeyButton()
    let decimalSeparatorKeyButton = KeyButton()
    let zeroKeyButton = KeyButton()
    let calculateKeyButton = OperationKeyButton()
    let additionKeyButton = OperationKeyButton()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.white
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addSubview(inputLabel)
        setupInputLabel()
        addSubview(separatorView)
        setupSeparatorView()
        addSubview(deleteKeyButton)
        addSubview(sevenKeyButton)
        addSubview(eightKeyButton)
        addSubview(nineKeyButton)
        addSubview(divisionKeyButton)
        addSubview(fourKeyButton)
        addSubview(fiveKeyButton)
        addSubview(sixKeyButton)
        addSubview(multiplicationKeyButton)
        addSubview(oneKeyButton)
        addSubview(twoKeyButton)
        addSubview(threeKeyButton)
        addSubview(subtractionKeyButton)
        addSubview(decimalSeparatorKeyButton)
        addSubview(zeroKeyButton)
        addSubview(calculateKeyButton)
        addSubview(additionKeyButton)
    }
    
    private func setupInputLabel() {
        inputLabel.textColor = Colors.secondaryText
        inputLabel.font = Fonts.default(size: 20, weight: .regular)
        inputLabel.numberOfLines = 1
        inputLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupSeparatorView() {
        separatorView.backgroundColor = Colors.primaryText
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layoutInputLabel()
        layoutSeparatorView()
        layoutDeleteKeyButton()
        layoutSevenKeyButton()
        layoutEightKeyButton()
        layoutNineKeyButton()
        layoutDivisionKeyButton()
        layoutFourKeyButton()
        layoutFiveKeyButton()
        layoutSixKeyButton()
        layoutMultiplicationKeyButton()
        layoutOneKeyButton()
        layoutTwoKeyButton()
        layoutThreeKeyButton()
        layoutSubstractionKeyButton()
        layoutDecimalSeparatorKeyButton()
        layoutZeroKeyButton()
        layoutCalculateKeyButton()
        layoutAdditionKeyButton()
    }
    
    private var keyButtonWidth: CGFloat {
        return (bounds.width - leftEdgeInsets * 2 - 3 * keyButtonSeparator) / 4
    }
    
    private var keyButtonSeparator: CGFloat {
        return bounds.width * 0.04
    }
    
    private var leftEdgeInsets: CGFloat {
        return keyButtonSeparator * 2
    }
    
    private func layoutInputLabel() {
        let x: CGFloat = leftEdgeInsets + 6
        let y: CGFloat = leftEdgeInsets
        let width = 3 * keyButtonWidth + 2 * keyButtonSeparator - 12
        let height: CGFloat = keyButtonWidth - 1
        let frame = CGRect(x: x, y: y, width: width, height: height)
        inputLabel.frame = frame
    }
    
    private func layoutSeparatorView() {
        let x: CGFloat = leftEdgeInsets
        let y = inputLabel.frame.origin.y + inputLabel.frame.size.height
        let width = bounds.width - 2 * x - keyButtonWidth - keyButtonSeparator
        let height: CGFloat = 1
        let frame = CGRect(x: x, y: y, width: width, height: height)
        separatorView.frame = frame
    }
    
    private func layoutDeleteKeyButton() {
        let y: CGFloat = leftEdgeInsets
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x = separatorView.frame.origin.x + separatorView.frame.size.width + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        deleteKeyButton.frame = frame
    }
    
    private func layoutSevenKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = leftEdgeInsets
        let y: CGFloat = separatorView.frame.origin.y + separatorView.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        sevenKeyButton.frame = frame
    }
    
    private func layoutEightKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = sevenKeyButton.frame.origin.x + sevenKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = separatorView.frame.origin.y + separatorView.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        eightKeyButton.frame = frame
    }
    
    private func layoutNineKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = eightKeyButton.frame.origin.x + eightKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = separatorView.frame.origin.y + separatorView.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nineKeyButton.frame = frame
    }
    
    private func layoutDivisionKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = nineKeyButton.frame.origin.x + nineKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = separatorView.frame.origin.y + separatorView.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        divisionKeyButton.frame = frame
    }
    
    private func layoutFourKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = leftEdgeInsets
        let y: CGFloat = sevenKeyButton.frame.origin.y + sevenKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        fourKeyButton.frame = frame
    }
    
    private func layoutFiveKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = fourKeyButton.frame.origin.x + fourKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = eightKeyButton.frame.origin.y + eightKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        fiveKeyButton.frame = frame
    }
    
    private func layoutSixKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = fiveKeyButton.frame.origin.x + fiveKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = nineKeyButton.frame.origin.y + nineKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        sixKeyButton.frame = frame
    }
    
    private func layoutMultiplicationKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = sixKeyButton.frame.origin.x + sixKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = divisionKeyButton.frame.origin.y + divisionKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        multiplicationKeyButton.frame = frame
    }
    
    private func layoutOneKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = leftEdgeInsets
        let y: CGFloat = sixKeyButton.frame.origin.y + sixKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        oneKeyButton.frame = frame
    }
    
    private func layoutTwoKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = oneKeyButton.frame.origin.x + oneKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = fiveKeyButton.frame.origin.y + fiveKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        twoKeyButton.frame = frame
    }
    
    private func layoutThreeKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = twoKeyButton.frame.origin.x + twoKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = sixKeyButton.frame.origin.y + sixKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        threeKeyButton.frame = frame
    }
    
    private func layoutSubstractionKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = sixKeyButton.frame.origin.x + sixKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = multiplicationKeyButton.frame.origin.y + multiplicationKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        subtractionKeyButton.frame = frame
    }
    
    private func layoutDecimalSeparatorKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = leftEdgeInsets
        let y: CGFloat = oneKeyButton.frame.origin.y + oneKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        decimalSeparatorKeyButton.frame = frame
    }
    
    private func layoutZeroKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = decimalSeparatorKeyButton.frame.origin.x + decimalSeparatorKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = twoKeyButton.frame.origin.y + twoKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        zeroKeyButton.frame = frame
    }
    
    private func layoutCalculateKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = zeroKeyButton.frame.origin.x + zeroKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = threeKeyButton.frame.origin.y + threeKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        calculateKeyButton.frame = frame
    }
    
    private func layoutAdditionKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = calculateKeyButton.frame.origin.x + calculateKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = subtractionKeyButton.frame.origin.y + subtractionKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        additionKeyButton.frame = frame
    }
    
    // MARL: Size
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let keyButtonSeparator: CGFloat = size.width * 0.04
        let keyButtonWidth = (size.width - leftEdgeInsets * 2 - 3 * keyButtonSeparator) / 4
        let height: CGFloat = leftEdgeInsets + keyButtonWidth + keyButtonSeparator + keyButtonWidth + keyButtonSeparator + keyButtonWidth + keyButtonSeparator + keyButtonWidth + keyButtonSeparator + keyButtonWidth + leftEdgeInsets
        let width = size.width
        let size = CGSize(width: width, height: height)
        return size
    }
    
}
}

final class KeyButton: AUIButton {
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        titleLabel?.font = Fonts.default(size: 20, weight: .semibold)
        setTitleColor(Colors.primaryText, for: .normal)
    }
    
    // MARK: States
    
    override var isHighlighted: Bool {
        willSet {
            willSetIsHighlighted(newValue)
        }
    }
    func willSetIsHighlighted(_ newValue: Bool) {
        if newValue {
            alpha = 0.6
        } else {
            alpha = 1
        }
    }
    
}

final class OperationKeyButton: AUIButton {
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        titleLabel?.font = Fonts.default(size: 20, weight: .semibold)
        setTitleColor(Colors.tertiaryText, for: .normal)
    }
    
    // MARK: States
    
    override var isHighlighted: Bool {
        willSet {
            willSetIsHighlighted(newValue)
        }
    }
    func willSetIsHighlighted(_ newValue: Bool) {
        if newValue {
            alpha = 0.6
        } else {
            alpha = 1
        }
    }
    
}
