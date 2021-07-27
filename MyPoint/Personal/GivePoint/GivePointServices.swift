//
//  GivePointServices.swift
//  MyPoint
//
//  Created by Nam Vu on 2/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class GivePointServices: BaseService {
    func checkExistedPhone(phoneNumber: String,
                           _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "access_token": storage.loginData?.accessToken ?? "",
            "phone_number": phoneNumber,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: CheckExistedPhoneResponse.self,
                    params: params,
                    pathURL: CommonAPI.checkExistedPhone) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func checkTransfer(password: String,
                       _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "access_token": storage.loginData?.accessToken ?? "",
            "password": password.sha256(),
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: CheckTransferPasswordResponse.self,
                    params: params,
                    pathURL: CommonAPI.checkTransferPassword) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func requestTransfer(model: GivePointModel,
                         _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        requestPOST(type: RequestTransferResponse.self,
                    params: model.toParams,
                    pathURL: CommonAPI.requestTransfer) { (response, status, _) in
                        callBack(response, status)
        }
    }
}
