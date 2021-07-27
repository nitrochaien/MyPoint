//
//  RequireInfoPopUpViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import Localize

final class RequireInfoPopUpViewController: UIViewController {

    @IBOutlet private weak var nickNameTextField: UITextField!
    @IBOutlet private weak var dateSelectionView: BaseSelectionView!
    @IBOutlet private weak var pickerView: UIDatePicker!
    @IBOutlet private weak var pickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    var didConfirm: (() -> Void)?

    private let presenter = RequireInfoPresenter()

    private let pickerHeight: CGFloat = 144
    private var isShowingPicker: Bool {
        return pickerHeightConstraint.constant == pickerHeight
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerHeightConstraint.constant = 0
        indicatorView.isHidden = true

        presenter.delegate = self

        dateSelectionView.setTitle(value: "main.date_placeholder".localized)
        dateSelectionView.onTapSelection = { [weak self] in
            guard let self = self else { return }
            self.nickNameTextField.resignFirstResponder()
            if self.isShowingPicker {
                self.hidePicker()
            } else {
                self.showPicker()
            }
        }

        pickerView.datePickerMode = .date

        pickerView.maximumDate = Date()
        pickerView.locale = Locale(identifier: Localize.shared.currentLanguage)
        pickerView.addTarget(self, action: #selector(onUpdate), for: .valueChanged)
    }

    @objc private func onUpdate(_ sender: UIDatePicker) {
        let selectedValue = sender.date.string(withFormat: DateFormat.profile)
        dateSelectionView.setTitle(value: selectedValue)
        presenter.date = selectedValue
    }

    private func showPicker() {
        pickerHeightConstraint.constant = pickerHeight
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    private func hidePicker() {
        pickerHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func onDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onConfirm(_ sender: Any) {
        presenter.nickname = nickNameTextField.text ?? ""

        if presenter.nickname.isEmpty {
            errorLabel.text = "main.require_nickname".localized
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.errorLabel.text = ""
            }
            return
        }
        if presenter.date.isEmpty {
            errorLabel.text = "main.require_birthday".localized
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.errorLabel.text = ""
            }
            return
        }
        errorLabel.text = ""
        indicatorView.startAnimating()
        indicatorView.isHidden = false

        presenter.updateProfile()
    }
}

extension RequireInfoPopUpViewController: BaseProtocols {
    func requestSuccess() {
        indicatorView.stopAnimating()
        dismiss(animated: true) { [weak self] in
            self?.didConfirm?()
        }
    }
}
