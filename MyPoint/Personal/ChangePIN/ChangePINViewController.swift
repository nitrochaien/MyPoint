//
//  ChangePINViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/12/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ChangePINViewController: UIViewController, AuthenciationViewProtocols {
    
    @IBOutlet private weak var headerView: AuthHeaderView!
    private var changePinView: ChangePINView!

    private var phone: String {
        return Storage.shared.registeredPhoneNumber ?? ""
    }
    private let presenter = ChangePINPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        initPINCodeView()
        headerView.delegate = self
        presenter.delegate = self

        changePinView.updateUI(phone: phone)
    }

    private func initPINCodeView() {
        let rect = getFrame()
        changePinView = ChangePINView(frame: rect)
        view.addSubview(changePinView)
        showView(input: changePinView)

        changePinView.didPressContinue = { [weak self] pinCode in
            guard let self = self else { return }
            self.resignFirstResponder()
            self.presenter.checkPassword(pinCode)
        }
    }

    fileprivate func showPINCodeScreen() {
        let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "CreatePINCodeViewController") as? CreatePINCodeViewController {
            controller.setParams(phone: phone, flowType: .changePinCode)
            navigationController?.pushViewController(controller)
        }
    }
}

extension ChangePINViewController: AuthHeaderViewDelegate {
    func onBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension ChangePINViewController: BaseProtocols {
    func requestSuccess() {
        showPINCodeScreen()
    }
}
