//
//  CreateNicknameViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CreateNicknameViewController: UIViewController, AuthenciationViewProtocols {

    private var nicknameView: CreateNicknameView!

    @IBOutlet private weak var headerView: AuthHeaderView!

    private let presenter = CreateNicknamePresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        headerView.delegate = self

        presenter.delegate = self

        initNicknameView()
    }

    func setParams(phone: String, pinCode: String) {
        presenter.phone = phone
        presenter.pinCode = pinCode

        let params = [
            "phone": phone,
            "pinCode": pinCode
        ]
        Storage.shared.registeringState = params
    }

    private func initNicknameView() {
        let rect = getFrame()
        nicknameView = CreateNicknameView(frame: rect)
        view.addSubview(nicknameView)
        showView(input: nicknameView)

        nicknameView.didPressContinue = { [weak self] nickname in
            guard let self = self else { return }
            self.resignFirstResponder()
            self.presenter.registerNickname(value: nickname)
        }
    }

    fileprivate func showSuccessScreen() {
        let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegisterSuccessViewController")
        navigationController?.pushViewController(controller)
    }
}

extension CreateNicknameViewController: AuthHeaderViewDelegate {}

extension CreateNicknameViewController: BaseProtocols {
    func requestSuccess() {
        Storage.shared.registeringState = nil
        showSuccessScreen()
    }
}
