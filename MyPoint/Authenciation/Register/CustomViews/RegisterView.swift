//
//  RegisterView.swift
//  MyPoint
//
//  Created by Nam Vu on 1/1/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class RegisterView: ScrollableView {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var confirmButton: ProceedButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var checkboxBtn: UIButton!
    @IBOutlet weak var tosBtn: UIButton!
    
    var didPressContinue: ((_ phoneNumber: String) -> Void)?
    var didPressLogin: (() -> Void)?
    var didPressTOS: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("RegisterView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)

        inputTextField.becomeFirstResponder()
        inputTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        inputTextField.delegate = self

        registerForKeyboardNotifications(with: [inputTextField])

        confirmButton.activeState = .inactive
        
        checkboxBtn.isExclusiveTouch = true
        
        tosBtn.isExclusiveTouch = true
        let blueColor = UIColor(hex: 0x6587FF)!
        let textTOS = "Chính sách và điều khoản sử dụng"
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0, weight: .medium),
            NSAttributedString.Key.foregroundColor: blueColor,
            NSAttributedString.Key.underlineColor: blueColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ] as [NSAttributedString.Key: Any]
        tosBtn.setAttributedTitle(.init(string: textTOS, attributes: attributes), for: .normal)
        tosBtn.setAttributedTitle(.init(string: textTOS, attributes: attributes), for: .highlighted)

        configDescriptionLabel()
    }

    @IBAction private func onPress(_ sender: Any) {
        guard let phone = inputTextField.text?.trimmed, !phone.isEmpty else {
            return
        }
        didPressContinue?(phone)
    }

    @IBAction func onPressLogin(_ sender: Any) {
        didPressLogin?()
    }
    
    @IBAction func checkboxBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkConfirmBtnState()
    }
    
    @IBAction func tosBtnTapped(_ sender: Any) {
        didPressTOS?()
    }
    
    func checkConfirmBtnState() {
        let text = inputTextField.text
        
        if let text = text, !text.isEmpty, text.isValidPhoneNumber, checkboxBtn.isSelected {
            confirmButton.activeState = .active
        } else {
            confirmButton.activeState = .inactive
        }
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
//        let text = textField.text
//
//        if let text = text, !text.isEmpty, text.isValidPhoneNumber, checkboxBtn.isSelected {
//            confirmButton.activeState = .active
//        } else {
//            confirmButton.activeState = .inactive
//        }
        checkConfirmBtnState()
    }

    private func configDescriptionLabel() {
        let descriptionText = "register.description".localized
        let attribute = descriptionLabel.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "2E5ECB")!],
                                 range: maxRange)

        let appName = "common.app_name".localized
        let hightlightedRange = (descriptionText as NSString).range(of: appName)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.medium, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "36399C")!],
                                 range: hightlightedRange)

        descriptionLabel.attributedText = attribute
    }
}

extension RegisterView: UITextFieldDelegate {
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
