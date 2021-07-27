//
//  CreatePINCodeViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CreatePINCodeViewController: UIViewController, AuthenciationViewProtocols {

    @IBOutlet private weak var headerView: AuthHeaderView!
    var pinCodeView: CreatePINCodeView!

    var phone = ""
    var flowType = AuthenFlowType.register

    override func viewDidLoad() {
        super.viewDidLoad()

        initPINCodeView()
        headerView.delegate = self
//        headerView.hideBackButton()

        pinCodeView.updateUI(flow: flowType, phone: phone)
    }

    func setParams(phone: String, flowType: AuthenFlowType) {
        self.phone = phone
        self.flowType = flowType
    }

    private func initPINCodeView() {
        let rect = getFrame()
        pinCodeView = CreatePINCodeView(frame: rect)
        view.addSubview(pinCodeView)
        showView(input: pinCodeView)

        pinCodeView.didPressContinue = { [weak self] pinCode in
            guard let self = self else { return }
            self.resignFirstResponder()
            self.showConfirmPINCodeScreen(with: pinCode)
        }
    }

    private func showConfirmPINCodeScreen(with pinCode: String) {
        let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
        if let controller = storyboard
            .instantiateViewController(withIdentifier: "ConfirmPINCodeViewController") as? ConfirmPINCodeViewController {
            controller.setParams(phone: phone,
                                 pinCode: pinCode,
                                 flowType: flowType)
            navigationController?.pushViewController(controller)
        }
    }
}

extension CreatePINCodeViewController: AuthHeaderViewDelegate {
    func onBack() {
        switch flowType {
        case .register:
            popToViewController(type: RegisterViewController.self)
        case .forgetPinCode:
            popToViewController(type: ReclaimPinCodeViewController.self)
        default:
            navigationController?.popViewController(animated: true)
        }
    }
}
