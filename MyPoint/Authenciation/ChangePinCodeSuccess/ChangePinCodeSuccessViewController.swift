//
//  ChangePinCodeSuccessViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/7/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class ChangePinCodeSuccessViewController: UIViewController {

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var nextButton: ProceedButton!

    var flowType = AuthenFlowType.register
    var phone = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }

    func setParams(phoneNumber: String) {
        phone = phoneNumber
    }

    private func initUI() {
        if flowType == .changePinCode {
            nextButton.setTitle("main.confirm".localized, for: .normal)
        }
        nextButton.activeState = .proceed
        configDescriptionLabel()
    }

    private func configDescriptionLabel() {
        let descriptionText = String(format: "reclaim_pin.description_success".localized, phone)
        let attribute = descriptionLabel.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "2E5ECB")!],
                                 range: maxRange)

        let hightlightedRange = (descriptionText as NSString).range(of: phone)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.medium, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "36399C")!],
                                 range: hightlightedRange)

        descriptionLabel.attributedText = attribute
    }

    @IBAction private func onPressNext(_ sender: Any) {
        switch flowType {
        case .changePinCode:
            popToViewController(type: SettingsViewController.self)
        case .forgetPinCode:
            setRoot(storyboard: "Authenciation", viewControllerId: "LoginViewController")
        default:
            break
        }
    }
}
