//
//  CheckInService.swift
//  MyPoint
//
//  Created by Nam Vu on 3/8/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class CheckInService: BaseService {

    func getRewardList(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "number_day": "7",
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: ListCheckinResponse.self,
                    params: params,
                    pathURL: CommonAPI.getListReward) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func submitCheckIn(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "get_customer_balance": "1"
        ]
        requestPOST(type: SubmitCheckInResponse.self,
                    params: params,
                    pathURL: CommonAPI.submitCheckIn) { (response, status, _) in
                        callBack(response, status)
        }
    }
}
