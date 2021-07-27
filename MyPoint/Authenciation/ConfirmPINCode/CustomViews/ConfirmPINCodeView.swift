//
//  ConfirmPINCodeView.swift
//  MyPoint
//
//  Created by Nam Vu on 1/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class ConfirmPINCodeView: ScrollableView {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var confirmButton: ProceedButton!
    @IBOutlet private weak var showHideButton: UIButton!

    private var isShowPassword = false

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
        Bundle.main.loadNibNamed("ConfirmPINCodeView", owner: self, options: nil)
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
        guard let pinCode = inputTextField.text?.trimmed else {
            return
        }
        didPressContinue?(pinCode)
    }

    @IBAction private func showHidePassword(_ sender: Any) {
        isShowPassword.toggle()
        showHideButton.setImage(isShowPassword ? UIImage(named: "ic_eye_on") : UIImage(named: "ic_eye_off"), for: .normal)
        inputTextField.isSecureTextEntry = !isShowPassword
    }

    @objc private func textDidChange(_ textField: UITextField) {
        let text = textField.text

        if let text = text?.trimmed, text.count == Defines.pinCodeLength {
            confirmButton.activeState = .active
        } else {
            confirmButton.activeState = .inactive
        }
    }
}

extension ConfirmPINCodeView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text, currentText.count < Defines.pinCodeLength {
            return true
        }
        if string.isEmpty {
            return true
        }
        return false
    }
}
