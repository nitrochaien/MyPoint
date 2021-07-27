//
//  OTPInputView.swift
//  MyPoint
//
//  Created by Nam Vu on 1/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class OTPInputView: ScrollableView {
    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var changePhoneButton: UIButton!
    @IBOutlet private weak var resendOTPButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var buttonContainerView: UIView!

    var sendOTPCode: ((_ otpCode: String) -> Void)?
    var resendOTPCode: (() -> Void)?
    var changePhone: (() -> Void)?
    var handleLockRegistering: (() -> Void)?

    private var resendTimer: Timer!
    private var resendCounter = 0
    private var fixedCounter = 0

    var phoneNumber = "" {
        didSet {
            configDescriptionLabel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("OTPInputView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)

        inputTextField.becomeFirstResponder()
        inputTextField.delegate = self
        inputTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        registerForKeyboardNotifications(with: [inputTextField])
    }

    func triggerResendTimer(with value: Int) {
        if value == 0 {
            showResendButton()
            return
        }
        resendCounter = value
        fixedCounter = value

        resendOTPButton.alpha = 0.5
        resendOTPButton.isUserInteractionEnabled = false

        resendOTPButton.setTitle(String(format: "otp.resend", resendCounter), for: .normal)

        resendTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateResendButton),
                                     userInfo: nil,
                                     repeats: true)
        resendTimer.fire()
    }

    func invalidateTimer() {
        if resendTimer != nil {
            resendTimer.invalidate()
        }
    }

    @objc private func updateResendButton() {
        resendCounter -= 1
        if resendCounter == 0 {
            showResendButton()
        } else {
            resendOTPButton.setTitle(String(format: "otp.resend".localized, resendCounter), for: .normal)
        }
    }

    private func showResendButton() {
        resendOTPButton.alpha = 1.0
        resendOTPButton.isUserInteractionEnabled = true
        resendOTPButton.setTitle("otp.resend_done".localized, for: .normal)
        invalidateTimer()
    }

    func startLoading() {
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        buttonContainerView.isHidden = true
    }

    func stopLoading() {
        indicatorView.isHidden = true
        indicatorView.stopAnimating()
        buttonContainerView.isHidden = false
    }

    @IBAction private func onPress(_ sender: UIButton) {
        if sender.tag == 0 {
            // Change Phone
            changePhone?()
        } else if sender.tag == 1 {
            // Resend OTP
            triggerResendTimer(with: fixedCounter)
            resendOTPCode?()
        }
    }

    @objc private func textDidChange(_ textField: UITextField) {
        guard let text = textField.text?.trimmed, !text.isEmpty else {
            return
        }
        if text.count == Defines.otpCodeLength {
            sendOTPCode?(text)
        }
    }

    private func configDescriptionLabel() {
        let descriptionText = String(format: "otp.description".localized, phoneNumber)
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
}

extension OTPInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text, currentText.count < Defines.otpCodeLength {
            return true
        }
        if string.isEmpty {
            return true
        }
        return false
    }
}
