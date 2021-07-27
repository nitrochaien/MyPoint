//
//  ConfirmPINCodePresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class ConfirmPINCodePresenter: APIResponseMethods {
    var pinCode = ""
    var phone = ""
    var newPinCode = ""
    var flowType = AuthenFlowType.register

    private let service = AuthenciationServices()

    weak var delegate: BaseProtocols?

    func isMatchedPINCode(with newPincode: String) -> Bool {
        let result = pinCode.compare(newPincode, options: .caseInsensitive, range: nil, locale: nil)
        return result == .orderedSame
    }

    func register() {
        let requestModel = RegisterRequestModel(accountName: phone,
                                                password: pinCode)
        service.register(requestModel: requestModel) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? LoginResponse {
                    guard self.noError(from: response) else { return }
                    Storage.shared.loginData = response.data
                    if let image = response.data?.workerSite?.avatar, !image.isEmpty {
                        Storage.shared.localUserProfilePic = response.data?.workerSite?.image
                    }
                    Storage.shared.registeredPhoneNumber = self.phone
                    self.delegate?.requestSuccess()
                }
            } else {
                self.showError()
            }
        }
    }

    func resetPassword() {
        let requestModel = ForgotPasswordRequestModel(loginName: phone, password: pinCode)
        service.resetPassword(requestModel: requestModel) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }
                    Storage.shared.registeredPhoneNumber = self.phone
                    self.delegate?.requestSuccess()
                }
            } else {
                self.showError()
            }
        }
    }

    func changePinCode() {
        service.changePinCode(password: pinCode) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
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
