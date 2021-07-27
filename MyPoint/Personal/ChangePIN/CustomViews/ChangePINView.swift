//
//  ChangePINView.swift
//  MyPoint
//
//  Created by Nam Vu on 2/12/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ChangePINView: ScrollableView {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var confirmButton: ProceedButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
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
        Bundle.main.loadNibNamed("ChangePINView", owner: self, options: nil)
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

    func updateUI(phone: String) {
        configDescriptionLabel(phoneNumber: phone)
    }

    private func configDescriptionLabel(phoneNumber: String) {
        let descriptionText = String(format: "change_pin.description".localized, phoneNumber)
        let attribute = descriptionLabel.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "2E5ECB")!],
                                 range: maxRange)

        let hightlightedRange = (descriptionText as NSString).range(of: phoneNumber)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.medium, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "36399C")!],
                                 range: hightlightedRange)

        descriptionLabel.attributedText = attribute
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

extension ChangePINView: UITextFieldDelegate {
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
