//
//  EnterCodeSuggestionTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 3/24/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class EnterCodeSuggestionTableViewCell: UITableViewCell {

    @IBOutlet private weak var codeTextField: UITextField!
    @IBOutlet private weak var confirmButton: UIButton!

    var didConfirm: ((_ text: String) -> Void)?
    var didDismiss: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        codeTextField.delegate = self
        codeTextField.resignFirstResponder()
        codeTextField.addTarget(self, action: #selector(onTextChanged), for: .editingChanged)
        disableButton()
    }

    func resignKeyboard() {
        codeTextField.resignFirstResponder()
    }

    @objc private func onTextChanged(_ textField: UITextField) {
        if let text = textField.text {
            if text.isValidPhoneNumber {
                enableButton()
            } else {
                disableButton()
            }
        }
    }

    private func disableButton() {
        confirmButton.isUserInteractionEnabled = false
        confirmButton.backgroundColor = UIColor(hexString: "#727C88")
    }

    private func enableButton() {
        confirmButton.isUserInteractionEnabled = true
        confirmButton.backgroundColor = UIColor(hexString: "#1556FC")
    }

    @IBAction private func onDismiss(_ sender: Any) {
        didDismiss?()
    }

    @IBAction private func onConfirm(_ sender: Any) {
        if let text = codeTextField.text, text.isValidPhoneNumber {
            didConfirm?(text)
        }
    }
}

extension EnterCodeSuggestionTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if let text = codeTextField.text, text.isValidPhoneNumber {
            didConfirm?(text)
        }

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text, currentText.count < Defines.maxPhoneNumberCount {
            return true
        }
        if string.isEmpty {
            return true
        }
        return false
    }
}
