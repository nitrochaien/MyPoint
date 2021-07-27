//
//  CreateNicknameView.swift
//  MyPoint
//
//  Created by Nam Vu on 1/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CreateNicknameView: ScrollableView {

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
        Bundle.main.loadNibNamed("CreateNicknameView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)

        inputTextField.becomeFirstResponder()
        inputTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        registerForKeyboardNotifications(with: [inputTextField])

        confirmButton.activeState = .inactive
    }

    @IBAction private func onPress(_ sender: Any) {
        guard let nickname = inputTextField.text?.trimmed, !nickname.isEmpty else {
            return
        }
        didPressContinue?(nickname)
    }

    @objc private func textDidChange(_ textField: UITextField) {
        let text = textField.text

        if let text = text?.trimmed, !text.isEmpty {
            confirmButton.activeState = .active
        } else {
            confirmButton.activeState = .inactive
        }
    }
}
