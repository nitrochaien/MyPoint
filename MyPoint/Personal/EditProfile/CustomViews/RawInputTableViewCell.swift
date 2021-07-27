//
//  RawInputTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/28/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class RawInputTableViewCell: UITableViewCell {

    @IBOutlet weak var inputTextField: UITextField!

    var didEndEditing: ((_ text: String?) -> Void)?
    var phoneDidChange: ((_ text: String, _ valid: Bool) -> Void)?

    var keyboardType: UIKeyboardType = .default {
        didSet {
            inputTextField.keyboardType = keyboardType

            if keyboardType == .numberPad {
                inputTextField.addDoneButtonOnKeyboard()
            }
        }
    }
    var enableBalanceChecking = false
    var enablePhoneChecking = false
    var enableNumberFormatting = false

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        inputTextField.clipsToBounds = true
        inputTextField.delegate = self
        inputTextField.layer.borderColor = UIColor(hexString: "#F1F3F4")?.cgColor
        inputTextField.layer.borderWidth = 1
        inputTextField.addPaddingLeft(12)

        inputTextField.addTarget(self, action: #selector(onTextChanged), for: .editingChanged)
    }

    func setText(_ text: String) {
        inputTextField.text = text
    }

    func setPlaceholder(_ text: String) {
        inputTextField.placeholder = text
    }

    @objc private func onTextChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }

        if enableBalanceChecking {
            let balanceString = Storage.shared.loginData?.workingSite?.customerBalance?.amountActive ?? ""
            if let point = Double(text), let balanceDouble = Double(balanceString) {
                let exceeds = point > balanceDouble
                inputTextField.textColor = exceeds ? .red : UIColor(hexString: "#032041")
            }
        }

        if enableNumberFormatting {
            if let text = inputTextField.text {
                let validText = text.replacingOccurrences(of: ".", with: "")
                if let doubleValue = Double(validText) {
                    inputTextField.text = doubleValue.formattedWithSeparator
                }
            }
        }

        if enablePhoneChecking {
            phoneDidChange?(text, text.isValidPhoneNumber)
        }
    }
}

extension RawInputTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?(textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard enablePhoneChecking else { return true }
        
        if let currentText = textField.text, currentText.count < Defines.maxPhoneNumberCount {
            return true
        }
        if string.isEmpty {
            return true
        }
        return false
    }
}
