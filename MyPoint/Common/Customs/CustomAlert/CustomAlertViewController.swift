//
//  CustomAlertViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    var onDismiss: (() -> Void)?
    
    func updateData(withTitle title: String, andContent content: String) {
        titleLabel.text = title

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 8.0
        let attribute = NSAttributedString(string: content,
                                           attributes: [.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                                        .foregroundColor: UIColor(hexString: "6C6A7C")!,
                                                        .paragraphStyle: paragraph])
        contentLabel.attributedText = attribute
    }

    @IBAction private func onConfirm(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.onDismiss?()
        }
    }
}
