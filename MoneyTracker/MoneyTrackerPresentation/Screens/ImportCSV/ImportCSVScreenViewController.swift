//
//  ImportCSVScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 26.02.2022.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

class ImportCSVScreenViewController: UIDocumentPickerViewController, UIDocumentPickerDelegate {
    
    // MARK: - Delegation
    
    var didPickDocument: ((URL) -> Void)?
    
    // MARK: - Data
    
    private(set) var appearance: Appearance
    
    // MARK: - Life cycle
    
    init(appearance: Appearance) {
        self.appearance = appearance
        let types = UTType.types(tag: "csv", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
        super.init(forOpeningContentTypes: types, asCopy: false)
        allowsMultipleSelection = false
        overrideUserInterfaceStyle = appearance.overrideUserInterfaceStyle
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Appearance
    
    func changeAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        overrideUserInterfaceStyle = appearance.overrideUserInterfaceStyle
    }
    
    // MARK: - UIDocumentPickerDelegate
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        didPickDocument?(url)
    }
    
}
