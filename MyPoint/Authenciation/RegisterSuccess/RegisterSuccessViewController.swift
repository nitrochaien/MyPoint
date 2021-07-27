//
//  RegisterSuccessViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class RegisterSuccessViewController: UIViewController {

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var nextButton: ProceedButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }

    private func initUI() {
        nextButton.activeState = .proceed

        let descriptionText = "register_success.description".localized
        let attribute = descriptionLabel.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "2E5ECB")!],
                                 range: maxRange)
        descriptionLabel.attributedText = attribute
    }

    @IBAction private func onPressNext(_ sender: Any) {
        setRoot(storyboard: "Tabbar", viewControllerId: "TabbarViewController")
    }
}
