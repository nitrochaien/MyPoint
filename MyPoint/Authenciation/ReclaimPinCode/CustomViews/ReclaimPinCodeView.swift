//
//  ReclaimPinCodeView.swift
//  MyPoint
//
//  Created by Nam Vu on 1/7/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class ReclaimPinCodeView: ScrollableView {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var confirmButton: ProceedButton!

    var didPressContinue: ((_ phoneNumber: String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("ReclaimPinCodeView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)

        inputTextField.becomeFirstResponder()
        inputTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        inputTextField.delegate = self

        registerForKeyboardNotifications(with: [inputTextField])

        confirmButton.activeState = .inactive
    }

    @IBAction private func onPress(_ sender: Any) {
        guard let phone = inputTextField.text?.trimmed, !phone.isEmpty else {
            return
        }
        didPressContinue?(phone)
    }

    @objc private func textDidChange(_ textField: UITextField) {
        let text = textField.text

        if let text = text, !text.isEmpty, text.isValidPhoneNumber {
            confirmButton.activeState = .active
        } else {
            confirmButton.activeState = .inactive
        }
    }
}

extension ReclaimPinCodeView: UITextFieldDelegate {
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
