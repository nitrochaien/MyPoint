//
//  ReclaimPinCodePresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/7/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class ReclaimPinCodePresenter: APIResponseMethods {
    weak var delegate: BaseProtocols?

    var phoneNumber = ""
    
    /// Cooldown time for request otp code again
    var resendAfterSecond = 0

    private let service = AuthenciationServices()

    func verifyPhoneNumber() {
        service.verifyRegisteredPhoneNumber(phone: phoneNumber) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? LoginResponse {
                    guard self.noError(from: response) else { return }
                    self.requestNewOTPCode()
                }
            } else {
                self.showError()
            }
        }
    }

    private func requestNewOTPCode() {
        let model = CreateOTPRequestModel(ownerId: phoneNumber, timeToLive: Defines.timeToLive)
        service.forgotPassCreateNewOTP(requestModel: model) { [weak self] (response, success) in
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
