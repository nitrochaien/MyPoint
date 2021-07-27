//
//  LoginPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class LoginPresenter: APIResponseMethods {
    private let service = AuthenciationServices()

    weak var delegate: BaseProtocols?

    var phoneNumber = ""
    var pinCode = ""

    func login() {
        let requestModel = LoginRequestModel(username: phoneNumber,
                                             password: pinCode)
        service.login(requestModel: requestModel) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? LoginResponse {
                    guard self.noError(from: response) else { return }

                    Storage.shared.loginData = response.data
                    if let image = response.data?.workerSite?.avatar, !image.isEmpty {
                        Storage.shared.localUserProfilePic = response.data?.workerSite?.image
                    }
                    Storage.shared.registeredPhoneNumber = self.phoneNumber

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
