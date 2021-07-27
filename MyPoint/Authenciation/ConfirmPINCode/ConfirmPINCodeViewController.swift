//
//  ConfirmPINCodeViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ConfirmPINCodeViewController: UIViewController, AuthenciationViewProtocols {

    var pinCodeView: ConfirmPINCodeView!

    private let presenter = ConfirmPINCodePresenter()

    @IBOutlet private weak var headerView: AuthHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initPINCodeView()
        presenter.delegate = self
        headerView.delegate = self
    }

    func setParams(phone: String,
                   pinCode: String,
                   flowType: AuthenFlowType) {
        presenter.pinCode = pinCode
        presenter.phone = phone
        presenter.flowType = flowType
    }

    private func initPINCodeView() {
        let rect = getFrame()
        pinCodeView = ConfirmPINCodeView(frame: rect)
        view.addSubview(pinCodeView)
        showView(input: pinCodeView)

        pinCodeView.didPressContinue = { [weak self] pinCode in
            guard let self = self else { return }
            let validatedPinCode = pinCode.trimmed
            if self.presenter.isMatchedPINCode(with: validatedPinCode) {
                self.resignFirstResponder()
                self.presenter.newPinCode = validatedPinCode

                switch self.presenter.flowType {
                case .register:
                    self.presenter.register()
                case .forgetPinCode:
                    self.presenter.resetPassword()
                case .changePinCode:
                    self.presenter.changePinCode()
                }
            } else {
                self.showCustomAlert(withTitle: "alert.wrong_pin".localized,
                                     andContent: "alert.wrong_pin_content".localized)
            }
        }
    }

    fileprivate func showCreateNicknameScreen() {
        let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "CreateNicknameViewController") as? CreateNicknameViewController {
            controller.setParams(phone: presenter.phone, pinCode: presenter.pinCode)
            navigationController?.pushViewController(controller)
        }
    }

    fileprivate func showSuccessScreen() {
        let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegisterSuccessViewController")
        navigationController?.pushViewController(controller)
    }

    fileprivate func showReclaimPINSuccess() {
        let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
        let id = "ChangePinCodeSuccessViewController"
        if let controller = storyboard
            .instantiateViewController(withIdentifier: id) as? ChangePinCodeSuccessViewController {
            controller.setParams(phoneNumber: presenter.phone)
            controller.flowType = presenter.flowType
            navigationController?.pushViewController(controller)
        }
    }
}

extension ConfirmPINCodeViewController: AuthHeaderViewDelegate {}

extension ConfirmPINCodeViewController: BaseProtocols {
    func requestSuccess() {
        switch self.presenter.flowType {
        case .register:
            showSuccessScreen()
        case .forgetPinCode,
             .changePinCode:
            showReclaimPINSuccess()
        }
    }
}
