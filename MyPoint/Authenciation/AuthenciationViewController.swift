//
//  AuthenciationViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 12/28/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

final class AuthenciationViewController: UIViewController {

    @IBOutlet private weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        configDescriptionLabel()
    }

    private func configDescriptionLabel() {
        let descriptionText = "authenciation.description".localized
        let attribute = descriptionLabel.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "2E5ECB")!],
                                 range: maxRange)

        let appName = "common.app_name".localized
        let hightlightedRange = (descriptionText as NSString).range(of: appName)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.medium, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "36399C")!],
                                 range: hightlightedRange)

        descriptionLabel.attributedText = attribute
    }

    @IBAction private func onPressLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        navigationController?.pushViewController(controller)
    }
    
    @IBAction private func onPressSignUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegisterViewController")
        navigationController?.pushViewController(controller)
    }

    @IBAction private func onTapButton(_ sender: Any) {
        setRoot(storyboard: "Tabbar", viewControllerId: "TabbarViewController")
    }
}
