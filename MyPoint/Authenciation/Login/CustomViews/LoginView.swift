//
//  LoginView.swift
//  MyPoint
//
//  Created by Nam Vu on 1/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class LoginView: ScrollableView {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var pinTextField: UITextField!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var showHideButton: UIButton!

    var didPressLogin: ((_ phoneNumber: String, _ pinCode: String) -> Void)?
    var didPressSignup: (() -> Void)?
    var didPress4G: (() -> Void)?
    var didPressForgotPassword: (() -> Void)?

    private var isShowPassword = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)

        configTextFields()
        deactiveLoginButton()
    }

    func setPhoneNumber(_ phone: String) {
        phoneTextField.text = phone
    }

    private func configTextFields() {
        phoneTextField.tag = 1
        phoneTextField.delegate = self
        pinTextField.tag = 2
        pinTextField.delegate = self

        phoneTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        pinTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        registerForKeyboardNotifications(with: [phoneTextField, pinTextField])
    }

    @IBAction private func onPressLogin(_ sender: Any) {
        didPressLogin?(phoneTextField.text!.trimmed, pinTextField.text!.trimmed)
    }

    @IBAction private func onPressSignUp(_ sender: Any) {
        didPressSignup?()
    }

    @IBAction private func forgotPassword(_ sender: Any) {
        didPressForgotPassword?()
    }

    @IBAction func onPress4G(_ sender: Any) {
        didPress4G?()
    }

    @IBAction private func onPressShowHidePassword(_ sender: Any) {
        isShowPassword.toggle()
        showHideButton.setImage(isShowPassword ? UIImage(named: "ic_eye_on") : UIImage(named: "ic_eye_off"), for: .normal)
        pinTextField.isSecureTextEntry = !isShowPassword
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        if validInputs {
            activeLoginButton()
        } else {
            deactiveLoginButton()
        }
    }

    private var validInputs: Bool {
        guard let phone = phoneTextField.text, !phone.isEmpty, phone.isValidPhoneNumber else {
            return false
        }
        guard let pinCode = pinTextField.text,
            !pinCode.isEmpty,
            pinCode.count == Defines.pinCodeLength else {
            return false
        }
        return true
    }

    private func activeLoginButton() {
        confirmButton.setBackgroundImage(UIImage(named: "btn_continue_background"), for: .normal)
        confirmButton.backgroundColor = .clear
        confirmButton.isUserInteractionEnabled = true
    }

    private func deactiveLoginButton() {
        confirmButton.backgroundColor = #colorLiteral(red: 0.5725490196, green: 0.5764705882, blue: 0.662745098, alpha: 0.5)
        confirmButton.setBackgroundImage(nil, for: .normal)
        confirmButton.isUserInteractionEnabled = false
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .continue {
            // change focus to pin textfield
            pinTextField.becomeFirstResponder()
        } else if textField.returnKeyType == .done {
            // filled all elements
            if validInputs {
                didPressLogin?(phoneTextField.text!.trimmed, pinTextField.text!.trimmed)
            }
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var max: Int
        if textField.tag == 1 {
            // Phone
            max = Defines.maxPhoneNumberCount
        } else {
            // Pin
            max = Defines.pinCodeLength
        }

        if let currentText = textField.text, currentText.count < max {
            return true
        }
        if string.isEmpty {
            return true
        }
        return false
    }
}
