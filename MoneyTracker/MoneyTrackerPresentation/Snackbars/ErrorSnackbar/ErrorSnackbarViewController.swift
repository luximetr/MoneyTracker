//
//  ErrorSnackbarViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 29.04.2022.
//

import AUIKit

class ErrorSnackbarViewController: AUIEmptyViewController {
    
    // MARK: - Data
    
    private var appearance: Appearance
    private(set) var message: String = ""
    
    // MARK: - Initializer
    
    init(appearance: Appearance) {
        self.appearance = appearance
        super.init()
    }
    
    // MARK: - View
    
    var errorSnackbarView: ErrorSnackbarView? {
        set { view = newValue }
        get { return view as? ErrorSnackbarView }
    }
    
    // MARK: - View - Setup
    
    override func setupView() {
        super.setupView()
        errorSnackbarView?.hide()
        errorSnackbarView?.dismissButton.addTarget(self, action: #selector(didTapOnDismissButton), for: .touchUpInside)
    }
    
    // MARK: - Show message
    
    private var dismissTimer: Timer?
    
    func showMessage(_ message: String) {
        self.message = message
        errorSnackbarView?.titleLabel.text = message
        errorSnackbarView?.updateFrame()
        errorSnackbarView?.showAnimated()
        startDismissTimer()
    }
    
    // MARK: - Dismiss button
    
    @objc
    private func didTapOnDismissButton() {
        dismiss()
    }
    
    private func startDismissTimer() {
        dismissTimer?.invalidate()
        dismissTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { timer in
            self.dismiss()
        })
    }
    
    private func dismiss() {
        dismissTimer?.invalidate()
        self.errorSnackbarView?.hideAnimated()
    }
}
