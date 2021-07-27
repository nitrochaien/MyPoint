//
//  TwoOptionsAlertViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class TwoOptionsAlertViewController: UIViewController {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!

    var handlePressLeftButton: (() -> Void)?
    var handlePressRightButton: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        leftButton.layer.borderWidth = 1
        leftButton.layer.borderColor = UIColor(hexString: "727C88")?.cgColor
    }

    func updateData(with model: TwoOptionsButtonModel) {
        headerLabel.text = model.title
        contentLabel.attributedText = model.content
        leftButton.setTitle(model.leftButtonTitle, for: .normal)
        rightButton.setTitle(model.rightButtonTitle, for: .normal)

        switch model.type {
        case .normal:
            rightButton.setBackgroundImage(UIImage(named: "btn_continue_background"), for: .normal)
            rightButton.backgroundColor = .clear
        case .destructive:
            rightButton.setBackgroundImage(nil, for: .normal)
            rightButton.backgroundColor = UIColor(hexString: "#E71D28")
        case .confirm:
            rightButton.setBackgroundImage(nil, for: .normal)
            rightButton.backgroundColor = UIColor(hexString: "#17AC65")
        }
    }
    
    func updateData(information: NSMutableAttributedString, with model: TwoOptionsButtonModel) {
        headerLabel.text = model.title
        contentLabel.attributedText = information
        leftButton.setTitle(model.leftButtonTitle, for: .normal)
        rightButton.setTitle(model.rightButtonTitle, for: .normal)
        switch model.type {
        case .normal:
            rightButton.setBackgroundImage(UIImage(named: "btn_continue_background"), for: .normal)
            rightButton.backgroundColor = .clear
        case .destructive:
            rightButton.setBackgroundImage(nil, for: .normal)
            rightButton.backgroundColor = UIColor(hexString: "#E71D28")
        case .confirm:
            rightButton.setBackgroundImage(nil, for: .normal)
            rightButton.backgroundColor = UIColor(hexString: "#17AC65")
        }
    }

    @IBAction private func onPressLeftButton(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.handlePressLeftButton?()
        }
    }

    @IBAction private func onPressRightButton(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.handlePressRightButton?()
        }
    }
}
