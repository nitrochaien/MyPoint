//
//  TelcoServices.swift
//  MyPoint
//
//  Created by Nam Vu on 4/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class TelcoServices: BaseService {
    func getTopupList(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params: [String: Any] = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "start": offset,
            "limit": limit,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: TelcoListResponse.self,
                    params: params,
                    pathURL: CommonAPI.getTopupList) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getMobileCardList(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params: [String: Any] = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "start": offset,
            "limit": limit,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: TelcoListResponse.self,
                    params: params,
                    pathURL: CommonAPI.getMobileCardList) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getMobileServiceList(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params: [String: Any] = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "start": offset,
            "limit": limit,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: TelcoListResponse.self,
                    params: params,
                    pathURL: CommonAPI.getMobileServiceList) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func redeemMobileCard(productId: String,
                          _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params: [String: Any] = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "product_id": productId,
            "get_customer_balance": "1",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: MobileServiceRedeemResponse.self,
                    params: params,
                    pathURL: CommonAPI.redeemMobileCard) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getMobileCardCode(itemId: String,
                           _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "product_item_id": itemId,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: UsableVoucherDetailResponse.self,
                    params: params,
                    pathURL: CommonAPI.getMobileCardCode) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func redeemMobileService(productId: String,
                             quantity: Int,
                             _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params: [String: Any] = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "product_id": productId,
            "get_customer_balance": "1",
            "quantity": quantity,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: MobileServiceRedeemResponse.self,
                    params: params,
                    pathURL: CommonAPI.redeemMobileService) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func redeemTopup(productId: String,
                     _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params: [String: Any] = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "product_id": productId,
            "get_customer_balance": "1",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: MobileServiceRedeemResponse.self,
                    params: params,
                    pathURL: CommonAPI.redeemTopup) { (response, status, _) in
                        callBack(response, status)
        }
    }
}
