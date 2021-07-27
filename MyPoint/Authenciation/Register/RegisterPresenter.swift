//
//  RegisterPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol RegisterPresenterDelgate: BaseProtocols {
    func handleAccountExisted()
}

final class RegisterPresenter: APIResponseMethods {
    private let service = AuthenciationServices()

    weak var delegate: RegisterPresenterDelgate?

    var phoneNumber = ""

    /// Cooldown time for request otp code again
    var resendAfterSecond = 0

    func verifyNewAccountNameForSignUp(with phoneNumber: String) {
        self.phoneNumber = phoneNumber
        
        service.requestAccountVerification(phoneNumber: phoneNumber) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }

                    if let errCode = response.errorCode,
                        errCode == Defines.ErrorCode.accountExisted.rawValue {
                        self.delegate?.handleAccountExisted()
                        return
                    }

                    self.requestNewOTPCode()
                }
            } else {
                self.showError()
            }
        }
    }

    private func requestNewOTPCode() {
        let model = CreateOTPRequestModel(ownerId: phoneNumber, timeToLive: Defines.timeToLive)
        service.createNewOTP(requestModel: model) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? CreateOTPResponse {
                    guard self.noError(from: response) else { return }

                    self.resendAfterSecond = response.data?.resendAfterSecond ?? 0

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
