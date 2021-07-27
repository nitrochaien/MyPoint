//
//  ChangePINPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class ChangePINPresenter: APIResponseMethods {
    weak var delegate: BaseProtocols?
    private let service = PersonalServices()

    func checkPassword(_ input: String) {
        service.checkPINValidation(input) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? PasswordCheckResponse {
                    guard self.noError(from: response) else { return }
                    self.delegate?.requestSuccess()
                }
            } else {
                self.showError()
            }
        }
    }

    func showError(message: String = "api.request_fail".localized) {
        delegate?.showError(message: message)
    }
}
