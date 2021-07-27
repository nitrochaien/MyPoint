//
//  AuthOTPPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol AuthOTPPresenterDelegate: BaseProtocols {
    func didGetAPICode(_ code: String)
}

extension AuthOTPPresenterDelegate where Self: AuthOTPViewController {
    func didGetAPICode(_ code: String) {
        showCustomAlert(withTitle: "api.otp".localized, andContent: code)
    }
}

class AuthOTPPresenter: APIResponseMethods {
    var phoneNumber = ""
    var flowType = AuthenFlowType.register
    var countDownValue = 0

    private let service = AuthenciationServices()

    weak var delegate: AuthOTPPresenterDelegate?

    func getLatestOTP() {
        service.getLatestOTP(phoneNumber: phoneNumber) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? LatestOTPResponse {
                    guard self.noError(from: response) else { return }

                    if let otpCode = response.data?.otpValue?.otpValue {
                        self.delegate?.didGetAPICode(otpCode)
                    }
                }
            } else {
                self.showError()
            }
        }
    }

    func verifyOTP(_ otp: String) {
        let model = VerifyOTPRequestModel(ownerId: phoneNumber,
                                          otp: otp,
                                          timeToDoNextEvent: Defines.timeToDoNextEvent,
                                          nextEventName: flowType == .register ? .signUp : .resetPassword)
        service.verifyOTP(requestModel: model) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? VerifyOtpResponse {
                    guard self.noError(from: response) else { return }
                    self.delegate?.requestSuccess()
                }
            } else {
                self.showError()
            }
        }
    }

    func resendOTP() {
        service.resendOTP(phoneNumber: phoneNumber) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? ResendOTPResponse {
                    guard self.noError(from: response) else { return }
//                    self.getLatestOTP()
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
