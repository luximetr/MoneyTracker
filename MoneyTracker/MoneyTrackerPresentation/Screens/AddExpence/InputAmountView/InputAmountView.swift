//
//  InputAmountView.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 12.03.2022.
//

import UIKit
import AUIKit

final class InputAmountView: AUIView {
    
    // MARK: Subviews
    
    let inputLabel = UILabel()
    let separatorView = UIView()
    let sevenKeyButton = KeyButton()
    let eightKeyButton = KeyButton()
    let nineKeyButton = KeyButton()
    let fourKeyButton = KeyButton()
    let fiveKeyButton = KeyButton()
    let sixKeyButton = KeyButton()
    let oneKeyButton = KeyButton()
    let twoKeyButton = KeyButton()
    let threeKeyButton = KeyButton()
    let decimalSeparatorKeyButton = KeyButton()
    let zeroKeyButton = KeyButton()
    let deleteKeyButton = KeyButton()
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        backgroundColor = Colors.secondaryBackground
        clipsToBounds = true
        addSubview(inputLabel)
        setupInputLabel()
        addSubview(separatorView)
        setupSeparatorView()
        addSubview(sevenKeyButton)
        addSubview(eightKeyButton)
        addSubview(nineKeyButton)
        addSubview(fourKeyButton)
        addSubview(fiveKeyButton)
        addSubview(sixKeyButton)
        addSubview(oneKeyButton)
        addSubview(twoKeyButton)
        addSubview(threeKeyButton)
        addSubview(decimalSeparatorKeyButton)
        addSubview(zeroKeyButton)
        addSubview(deleteKeyButton)
    }
    
    private func setupInputLabel() {
        inputLabel.textColor = Colors.secondaryText
        inputLabel.font = Fonts.default(size: 17, weight: .regular)
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
        layoutInputLabel()
        layoutSeparatorView()
        layoutSevenKeyButton()
        layoutEightKeyButton()
        layoutNineKeyButton()
        layoutFourKeyButton()
        layoutFiveKeyButton()
        layoutSixKeyButton()
        layoutOneKeyButton()
        layoutTwoKeyButton()
        layoutThreeKeyButton()
        layoutDecimalSeparatorKeyButton()
        layoutZeroKeyButton()
        layoutDeleteKeyButton()
    }
    
    private func layoutInputLabel() {
        let x: CGFloat = 30
        let y: CGFloat = 16
        let width = bounds.width - 2 * x
        let height: CGFloat = 24
        let frame = CGRect(x: x, y: y, width: width, height: height)
        inputLabel.frame = frame
    }
    
    private func layoutSeparatorView() {
        let x: CGFloat = 20
        let y = inputLabel.frame.origin.y + inputLabel.frame.size.height + 4
        let width = bounds.width - 2 * x
        let height: CGFloat = 1
        let frame = CGRect(x: x, y: y, width: width, height: height)
        separatorView.frame = frame
    }
    
    private var keyButtonWidth: CGFloat {
        return (bounds.width - 20 * 2 - 2 * keyButtonSeparator) / 3
    }
    
    private var keyButtonSeparator: CGFloat {
        return bounds.width * 0.06
    }
    
    private func layoutSevenKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = 20
        let y: CGFloat = separatorView.frame.origin.y + separatorView.frame.size.height + 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        sevenKeyButton.frame = frame
    }
    
    private func layoutEightKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = sevenKeyButton.frame.origin.x + sevenKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = separatorView.frame.origin.y + separatorView.frame.size.height + 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        eightKeyButton.frame = frame
    }
    
    private func layoutNineKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = eightKeyButton.frame.origin.x + eightKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = separatorView.frame.origin.y + separatorView.frame.size.height + 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        nineKeyButton.frame = frame
    }
    
    private func layoutFourKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = 20
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
    
    private func layoutOneKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = 20
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
    
    private func layoutDecimalSeparatorKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = 20
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
    
    private func layoutDeleteKeyButton() {
        let width: CGFloat = keyButtonWidth
        let height: CGFloat = keyButtonWidth
        let x: CGFloat = zeroKeyButton.frame.origin.x + zeroKeyButton.frame.size.width + keyButtonSeparator
        let y: CGFloat = threeKeyButton.frame.origin.y + threeKeyButton.frame.size.height + keyButtonSeparator
        let frame = CGRect(x: x, y: y, width: width, height: height)
        deleteKeyButton.frame = frame
    }
    
    // MARL: Size
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let keyButtonSeparator: CGFloat = size.width * 0.0722
        let keyButtonWidth = (size.width - 20 * 2 - 2 * keyButtonSeparator) / 3
        let height: CGFloat = 16 + 24 + 4 + 1 + 16 + keyButtonWidth + keyButtonSeparator + keyButtonWidth + keyButtonSeparator + keyButtonWidth + keyButtonSeparator + keyButtonWidth + 16
        let width = size.width
        let size = CGSize(width: width, height: height)
        return size
    }
    
}

final class KeyButton: AUIButton {
    
    // MARK: Setup
    
    override func setup() {
        super.setup()
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = Colors.black.cgColor
        titleLabel?.font = Fonts.default(size: 20, weight: .semibold)
        setTitleColor(Colors.primaryText, for: .normal)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
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
