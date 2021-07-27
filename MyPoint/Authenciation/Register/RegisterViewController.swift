//
//  RegisterViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import SafariServices

final class RegisterViewController: UIViewController, AuthenciationViewProtocols {

    private var registerView: RegisterView!
    @IBOutlet private weak var headerView: AuthHeaderView!

    private let presenter = RegisterPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        headerView.hideBackButton()
        headerView.delegate = self
        presenter.delegate = self

        initRegisterView()
    }

    private func initRegisterView() {
        let rect = getFrame()
        registerView = RegisterView(frame: rect)
        view.addSubview(registerView)
        showView(input: registerView)

        registerView.didPressContinue = { [weak self] phoneNumber in
            guard let self = self else { return }
            self.resignFirstResponder()
            self.presenter.verifyNewAccountNameForSignUp(with: phoneNumber)
        }
        registerView.didPressLogin = { [weak self] in
            self?.setRoot(storyboard: "Authenciation", viewControllerId: "LoginViewController")
        }
        registerView.didPressTOS = { [weak self] in
            guard let self = self else {
                return
            }
            
            let urlString = "https://sites.google.com/i-com.vn/termsandconditions/"
            
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                vc.delegate = self
                
                self.present(vc, animated: true)
            }
        }
    }

    fileprivate func showOTPScreen() {
        let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
        if let controller = storyboard
            .instantiateViewController(withIdentifier: "AuthOTPViewController") as? AuthOTPViewController {
            controller.setParams(phoneNumber: presenter.phoneNumber,
                                 flowType: .register,
                                 countdownValue: presenter.resendAfterSecond)
            navigationController?.pushViewController(controller)
        }
    }
}

extension RegisterViewController: AuthHeaderViewDelegate {}

extension RegisterViewController: RegisterPresenterDelgate {
    func requestSuccess() {
        showOTPScreen()
    }

    func handleAccountExisted() {
        showTwoButtonsAlert(with: .accountExistAlert,
                            rightButtonCompletion: { [weak self] in
            self?.showLoginScreen()
        })
    }

    private func showLoginScreen() {
        let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
        if let loginVC = storyboard
            .instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            loginVC.setPhoneNumber(presenter.phoneNumber)

            let transition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            transition.type = .fade
            transition.subtype = .fromBottom
            navigationController?.view.layer.add(transition, forKey: nil)
            navigationController?.pushViewController(loginVC, animated: false)
        }
    }
}

extension RegisterViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
