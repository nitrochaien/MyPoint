//
//  ScanningServices.swift
//  MyPoint
//
//  Created by Nam Vu on 5/6/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class ScanningServices: BaseService {
    func getOneTimeCardNumber(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: OneTimeCodeResponse.self,
                    params: params,
                    pathURL: CommonAPI.getOneTimeCode) { (response, status, _) in
                        callBack(response, status)
        }
    }
}
