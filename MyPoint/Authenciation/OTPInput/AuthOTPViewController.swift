//
//  AuthOTPViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class AuthOTPViewController: UIViewController, AuthenciationViewProtocols {

    @IBOutlet private weak var headerView: AuthHeaderView!
    fileprivate var OTPView: OTPInputView!
    private let presenter = AuthOTPPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        headerView.delegate = self
        headerView.hideBackButton()

        initOTPView()
        presenter.delegate = self
//        presenter.getLatestOTP()
    }

    func setParams(phoneNumber: String,
                   flowType: AuthenFlowType,
                   countdownValue: Int) {
        presenter.phoneNumber = phoneNumber
        presenter.flowType = flowType
        presenter.countDownValue = countdownValue
    }

    private func initOTPView() {
        let rect = getFrame()
        OTPView = OTPInputView(frame: rect)
        view.addSubview(OTPView)
        showView(input: OTPView)
        OTPView.phoneNumber = presenter.phoneNumber
        OTPView.triggerResendTimer(with: presenter.countDownValue)

        OTPView.changePhone = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        OTPView.resendOTPCode = {
            self.presenter.resendOTP()
        }
        OTPView.sendOTPCode = { [weak self] code in
            guard let self = self else { return }
            self.OTPView.startLoading()
            self.presenter.verifyOTP(code)
        }
//        OTPView.handleLockRegistering = { [weak self] in
//            guard let self = self else { return }

//            self.OTPView.invalidateTimer()
//            let lockAlert = String(format: "alert.lock_registering".localized,
//                                   Defines.daysOfLockRegistering,
//                                   Defines.hotline)
//            self.showCustomAlert(withTitle: "alert.wrong_pin".localized, andContent: lockAlert) { [weak self] in
//                self?.navigationController?.popToRootViewController(animated: true)
//            }
//        }
    }

    fileprivate func showPINCodeScreen() {
        let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "CreatePINCodeViewController") as? CreatePINCodeViewController {
            controller.setParams(phone: presenter.phoneNumber, flowType: presenter.flowType)
            navigationController?.pushViewController(controller)
        }
    }
}

extension AuthOTPViewController: AuthHeaderViewDelegate {}

extension AuthOTPViewController: AuthOTPPresenterDelegate {
    func requestSuccess() {
        OTPView.stopLoading()
        OTPView.invalidateTimer()
        showPINCodeScreen()
    }

    func showError(message: String) {
        OTPView.stopLoading()
        showCustomAlert(withTitle: "api.error".localized, andContent: message)
    }
}
