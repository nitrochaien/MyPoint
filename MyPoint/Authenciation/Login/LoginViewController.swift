//
//  LoginViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, AuthenciationViewProtocols {

    private var loginInputView: LoginView!
    @IBOutlet private weak var headerView: AuthHeaderView!

    private let presenter = LoginPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        headerView.delegate = self
        presenter.delegate = self

        headerView.hideBackButton()

        initLoginView()
    }

    func setPhoneNumber(_ phone: String) {
        presenter.phoneNumber = phone
    }

    private func initLoginView() {
        let rect = getFrame()
        loginInputView = LoginView(frame: rect)
        view.addSubview(loginInputView)
        showView(input: loginInputView)
        loginInputView.setPhoneNumber(presenter.phoneNumber)

        loginInputView.didPressLogin = { [weak self] phone, pinCode in
            guard let self = self else { return }
            self.presenter.phoneNumber = phone
            self.presenter.pinCode = pinCode
            self.presenter.login()
        }
        loginInputView.didPressSignup = { [weak self] in
            self?.setRoot(storyboard: "Authenciation", viewControllerId: "RegisterViewController")
        }
        loginInputView.didPressForgotPassword = { [weak self] in
            let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ReclaimPinCodeViewController")
            self?.navigationController?.pushViewController(controller)
        }
        loginInputView.didPress4G = { [weak self] in
            self?.showCustomAlert(withTitle: "login.sorry".localized,
                            andContent: "login.not_available".localized)
        }
    }
}

extension LoginViewController: AuthHeaderViewDelegate {}

extension LoginViewController: BaseProtocols {
    func
      requestSuccess() {
        setRoot(storyboard: "Tabbar", viewControllerId: "TabbarViewController")
    }
}
