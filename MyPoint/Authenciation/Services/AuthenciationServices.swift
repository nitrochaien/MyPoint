//
//  AuthenciationServices.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

final class AuthenciationServices: BaseService {
    func requestAccountVerification(phoneNumber: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "account_name": phoneNumber,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: GeneralResponse.self,
                    params: params,
                    pathURL: CommonAPI.verifyNewAccount) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func createNewOTP(requestModel: CreateOTPRequestModel, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        requestPOST(type: CreateOTPResponse.self,
                    params: requestModel.toParams,
                    pathURL: CommonAPI.createNewOTP) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func forgotPassCreateNewOTP(requestModel: CreateOTPRequestModel, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        requestPOST(type: CreateOTPResponse.self,
                    params: requestModel.toParams,
                    pathURL: CommonAPI.forgotPassCreateNewOTP) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getLatestOTP(phoneNumber: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "owner_id": phoneNumber,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: LatestOTPResponse.self,
                    params: params,
                    pathURL: CommonAPI.getLatestOTP) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func verifyOTP(requestModel: VerifyOTPRequestModel, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        var pathURL: String
        if requestModel.nextEventName == .signUp {
            pathURL = CommonAPI.verifyOTP
        } else {
            pathURL = CommonAPI.forgotPassVerifyOTP
        }
        requestPOST(type: VerifyOtpResponse.self,
                    params: requestModel.toParams,
                    pathURL: pathURL) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func resendOTP(phoneNumber: String,
                   _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "owner_id": phoneNumber,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: ResendOTPResponse.self,
                    params: params,
                    pathURL: CommonAPI.resendOTP) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func register(requestModel: RegisterRequestModel, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        requestPOST(type: LoginResponse.self,
                    params: requestModel.toParams,
                    pathURL: CommonAPI.register) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func login(requestModel: LoginRequestModel, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        requestPOST(type: LoginResponse.self,
                    params: requestModel.toParams,
                    pathURL: CommonAPI.login) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func verifyRegisteredPhoneNumber(phone: String,
                                     _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        requestPOST(type: LoginResponse.self,
                    params: ["login_name": phone,
                             "lang": Localize.shared.currentLanguage],
                    pathURL: CommonAPI.accountPasswordForgetVerifyAccountName) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func resetPassword(requestModel: ForgotPasswordRequestModel,
                       _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        requestPOST(type: GeneralResponse.self,
                    params: requestModel.toParams,
                    pathURL: CommonAPI.accountPasswordReset) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func changePinCode(password: String,
                       _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = ["login_name": Storage.shared.registeredPhoneNumber ?? "",
                      "password": password.sha256(),
                      "access_token": Storage.shared.loginData?.accessToken ?? "",
                      "lang": Localize.shared.currentLanguage]
        requestPOST(type: GeneralResponse.self,
                    params: params,
                    pathURL: CommonAPI.accountPasswordChange) { (response, status, _) in
                        callBack(response, status)
        }
    }
}
