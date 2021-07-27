//
//  SplashScreenServices.swift
//  MyPoint
//
//  Created by Nam Vu on 1/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class SplashScreenServices: BaseService {
    func requestAccessTokenStatus(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared

        let params = [
            "access_token": storage.loginData?.accessToken ?? "",
            "username": storage.registeredPhoneNumber ?? "",
            "device_key": storage.deviceToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: LoginResponse.self,
                    params: params,
                    pathURL: CommonAPI.accountAccessTokenRefresh) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func requestCategoryList(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: InterestedResponse.self,
                    params: params,
                    pathURL: CommonAPI.getAllCategories) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func requestSubCategories(codes: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "category_codes": codes
        ]
        requestPOST(type: GeneralResponse.self,
                    params: params,
                    pathURL: CommonAPI.categorySubscribeList) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func requestUnsubCategories(codes: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "category_codes": codes
        ]
        requestPOST(type: GeneralResponse.self,
                    params: params,
                    pathURL: CommonAPI.categoryUnsubscribeList) { (response, status, _) in
                        callBack(response, status)
        }
    }
}
