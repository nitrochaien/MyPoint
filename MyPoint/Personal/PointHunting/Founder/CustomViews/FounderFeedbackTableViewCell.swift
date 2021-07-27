//
//  FounderFeedbackTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class FounderFeedbackTableViewCell: UITableViewCell {

    @IBOutlet private weak var textView: UITextView!

    var onTextChanged: ((_ text: String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        textView.delegate = self
        textView.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        textView.addDoneButtonOnKeyboard()
    }
}

extension FounderFeedbackTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onTextChanged?(textView.text ?? "")
    }
}
