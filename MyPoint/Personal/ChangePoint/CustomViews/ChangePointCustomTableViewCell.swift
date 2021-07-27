//
//  ChangePointCustomTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ChangePointCustomTableViewCell: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pinImageView: UIImageView!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var resultView: UIView!
    @IBOutlet private weak var resultLabel: UILabel!

    var textDidChange: ((_ text: String?) -> Void)?
    var beginEditing: (() -> Void)?

    var isChecked: Bool = true {
        didSet {
            if isChecked {
                containerView.layer.cornerRadius = 8
                containerView.layer.borderWidth = 0
                pinImageView.image = UIImage(named: "ic_dot")

                containerView.addShadow(ofColor: .lightGray,
                                       radius: 8,
                                       offset: .zero,
                                       opacity: 0.5)
            } else {
                containerView.layer.cornerRadius = 8
                containerView.layer.borderWidth = 1
                containerView.layer.borderColor = UIColor(hexString: "#F1F3F4")?.cgColor
                pinImageView.image = nil

                containerView.addShadow(ofColor: .white,
                                       radius: 0,
                                       offset: .zero,
                                       opacity: 0.0)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        resultView.isHidden = true
        inputTextField.addTarget(self, action: #selector(onTextChanged), for: .editingChanged)
        inputTextField.delegate = self
    }

    private func showKeyboard() {
        inputTextField.becomeFirstResponder()
    }

    private func hideKeyboard() {
        inputTextField.resignFirstResponder()
    }

    @objc private func onTextChanged(_ textField: UITextField) {
        textDidChange?(textField.text)

        if let text = textField.text, !text.isEmpty {
            resultView.isHidden = false

            let descriptionText = String(format: "change_point.result".localized, text)
            let attribute = resultLabel.getAttributeSpacing(inputText: descriptionText, lineSpacing: 0.0)
            let maxRange = NSRange(location: 0, length: descriptionText.count)
            attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 14),
                                      .foregroundColor: UIColor(hexString: "#727C88")!],
                                     range: maxRange)

            let hightlightedRange = (descriptionText as NSString).range(of: text)
            attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium),
                                      .foregroundColor: UIColor(hexString: "#032041")!],
                                     range: hightlightedRange)

            resultLabel.attributedText = attribute

        } else {
            resultView.isHidden = true
        }
    }
}

extension ChangePointCustomTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        beginEditing?()
    }
}
