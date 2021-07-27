//
//  InputInviteCodeTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class InputInviteCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!

    var didConfirm: ((_ text: String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        codeTextField.delegate = self
        codeTextField.addTarget(self, action: #selector(onTextChanged), for: .editingChanged)
        disableButton()
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
        confirmButton.backgroundColor = UIColor(hexString: "#1EB36C")
    }

    @IBAction private func onConfirm(_ sender: Any) {
        if let text = codeTextField.text, text.isValidPhoneNumber {
            didConfirm?(text)
        }
    }
}

extension InputInviteCodeTableViewCell: UITextFieldDelegate {
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
