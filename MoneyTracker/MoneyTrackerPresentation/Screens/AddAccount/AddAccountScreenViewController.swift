//
//  AddAccountScreenViewController.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 10.02.2022.
//

import UIKit
import AUIKit

final class AddAccountScreenViewController: AUIStatusBarScreenViewController {
    
    // MARK: Delegation
    
    //var addCategoryClosure: ((AddingCategory) -> Void)?
    
    // MARK: Localizer
    
    private lazy var localizer: ScreenLocalizer = {
        let localizer = ScreenLocalizer(language: .english, stringsTableName: "AddAccountScreenStrings")
        return localizer
    }()
    
    // MARK: View
    
    override func loadView() {
        view = AddAccountScreenView()
    }
    
    private var addAccountScreenView: AddAccountScreenView! {
        return view as? AddAccountScreenView
    }
    
    private let colorsCollectionViewController = AUIEmptyCollectionViewController()
    
    private func setupColorsCollectionViewController() {
        colorsCollectionViewController.collectionView = addAccountScreenView.colorsCollectionView
    }
    
    // MARK: Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAccountScreenView.titleLabel.text = localizer.localizeText("title")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        addAccountScreenView.addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        addAccountScreenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        addAccountScreenView.colorsTitleLabel.text = localizer.localizeText("colorsTitle")
        setupColorsCollectionViewController()
        setColorsCollectionViewControllerContent()
    }
    
    // MARK: Events
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrameEndUser = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameEndUser.cgRectValue
        addAccountScreenView.setKeyboardFrame(keyboardFrame)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        addAccountScreenView.setKeyboardFrame(nil)
    }
    
    @objc private func add() {
        
    }
    
    private func didSelectColor() {
        print("didSelectColor")
    }
    
    // MARK: Content
    
    private func setColorsCollectionViewControllerContent() {
        var sectionContollers: [AUICollectionViewSectionController] = []
        let sectionContoller = AUIEmptyCollectionViewSectionController()
        var cellControllers: [AUICollectionViewCellController] = []
        for _ in 0..<20 {
            let cellController = ColorCollectionViewCellController(color: NSObject())
            cellController.cellForItemAtIndexPathClosure = { [weak self] indexPath in
                guard let self = self else { return UICollectionViewCell() }
                let cell = self.addAccountScreenView.colorCollectionViewCell(indexPath)
                cell.colorView.backgroundColor = .red
                return cell
            }
            cellController.sizeForCellClosure = { [weak self] in
                guard let self = self else { return .zero }
                let size = self.addAccountScreenView.colorCollectionViewCellSize()
                return size
            }
            cellController.didSelectClosure = { [weak self] in
                guard let self = self else { return }
                self.didSelectColor()
            }
            cellControllers.append(cellController)
        }
        sectionContoller.cellControllers = cellControllers
        sectionContollers.append(sectionContoller)
        colorsCollectionViewController.sectionControllers = sectionContollers
    }
    
}


