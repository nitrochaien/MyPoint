//
//  GivePointInputPINView.swift
//  MyPoint
//
//  Created by Nam Vu on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class GivePointInputPINView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var pinTextField: UITextField!
    @IBOutlet private weak var confirmButton: UIButton!

    var pinCode = ""

    var onConfirm: ((_ pinCode: String) -> Void)?
    var onDismiss: (() -> Void)?
    var onForgotPassword: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("GivePointInputPINView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)

        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        containerView.addGestureRecognizer(swipeGesture)

        pinTextField.addTarget(self, action: #selector(onTextChanged), for: .editingChanged)
        pinTextField.delegate = self

        disableButton()
    }

    func focus() {
        pinTextField.becomeFirstResponder()
    }

    func reset() {
        pinTextField.text = nil
    }

    @objc private func onTextChanged(_ textField: UITextField) {
        let text = textField.text
        pinCode = text ?? ""

        if let text = text?.trimmed, text.count == Defines.pinCodeLength {
            enableButton()
        } else {
            disableButton()
        }
    }

    @objc private func onSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .down {
            dismiss()
        }
    }

    private func disableButton() {
        confirmButton.setBackgroundImage(nil, for: .normal)
        confirmButton.backgroundColor = UIColor(hexString: "#98A1AF", transparency: 0.5)
        confirmButton.isUserInteractionEnabled = false
    }

    private func enableButton() {
        confirmButton.setBackgroundImage(UIImage(named: "btn_continue_background"), for: .normal)
        confirmButton.backgroundColor = .white
        confirmButton.isUserInteractionEnabled = true
    }

    private func dismiss() {
        onDismiss?()
    }

    @IBAction private func onTapButtonDown(_ sender: Any) {
        dismiss()
    }

    @IBAction private func onConfirm(_ sender: Any) {
        dismiss()
        onConfirm?(pinCode)
    }

    @IBAction private func onForgotPassword(_ sender: Any) {
        onForgotPassword?()
    }
}

extension GivePointInputPINView: UITextFieldDelegate {
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
