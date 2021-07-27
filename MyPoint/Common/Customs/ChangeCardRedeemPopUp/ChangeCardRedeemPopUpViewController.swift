//
//  ChangeCardRedeemPopUpViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/7/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ChangeCardRedeemPopUpViewController: UIViewController {

    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var codeView: UIView!
    
    var didSelectProceed: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCopy))
        codeView.addGestureRecognizer(tapGesture)
    }

    @objc private func onCopy() {
        UIPasteboard.general.string = codeLabel.text
    }

    @IBAction private func onConfirm(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.didSelectProceed?()
        }
    }

    @IBAction private func onDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setData(_ dueDate: String, code: String) {
        let content = String(format: "alert.change_card_success".localized, dueDate)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 8.0
        let attribute = NSAttributedString(string: content,
                                           attributes: [.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                                        .foregroundColor: UIColor(hexString: "#032041")!,
                                                        .paragraphStyle: paragraph])
        contentLabel.attributedText = attribute

        codeLabel.text = code
    }
}
