//
//  ReclaimPinCodeViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/7/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ReclaimPinCodeViewController: UIViewController, AuthenciationViewProtocols {

    private var phoneView: ReclaimPinCodeView!
    @IBOutlet private weak var headerView: AuthHeaderView!

    private let presenter = ReclaimPinCodePresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        headerView.delegate = self
        presenter.delegate = self

        initRegisterView()

    }

    private func initRegisterView() {
        let rect = getFrame()
        phoneView = ReclaimPinCodeView(frame: rect)
        view.addSubview(phoneView)
        showView(input: phoneView)

        phoneView.didPressContinue = { [weak self] phoneNumber in
            guard let self = self else { return }
            self.resignFirstResponder()
            self.presenter.phoneNumber = phoneNumber
            self.presenter.verifyPhoneNumber()
        }
    }

    fileprivate func showOTPScreen() {
        let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
        if let controller = storyboard
            .instantiateViewController(withIdentifier: "AuthOTPViewController") as? AuthOTPViewController {
            controller.setParams(phoneNumber: presenter.phoneNumber,
                                 flowType: .forgetPinCode,
                                 countdownValue: presenter.resendAfterSecond)
            navigationController?.pushViewController(controller)
        }
    }

}

extension ReclaimPinCodeViewController: AuthHeaderViewDelegate {}

extension ReclaimPinCodeViewController: BaseProtocols {
    func requestSuccess() {
        showOTPScreen()
    }
}
