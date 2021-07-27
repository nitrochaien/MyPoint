//
//  CashbackService.swift
//  MyPoint
//
//  Created by Nam Vu on 7/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class CashbackService: BaseService {
    func getCampaign(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params: [String: Any] = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "limit": limit,
            "start": offset
        ]
        requestPOST(type: AffiliateAccessTradeCampaignGetListResponse.self,
                    params: params,
                    pathURL: CommonAPI.getCampaign) { (response, status, _) in
            callBack(response, status)
        }
    }

    func getCampaignDetail(id: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "affiliate_campaign_id": id
        ]
        requestPOST(type: CashbackDetailResponse.self,
                    params: params,
                    pathURL: CommonAPI.getCampaignDetail) { (response, status, _) in
            callBack(response, status)
        }
    }

    func recordClickRequest(id: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "affiliate_campaign_id": id,
            "affiliate_category_id": "0"
        ]
        requestPOST(type: GeneralResponse.self,
                    params: params,
                    pathURL: CommonAPI.recordClickRequest) { (response, status, _) in
            callBack(response, status)
        }
    }

    func requestCampaignOrder(type: CashbackTransactionModel.TransactionType,
                              _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        var params: [String: Any] = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? ""
        ]
        params.merge(dict: type.params)
        requestPOST(type: CashbackTransactionResponse.self,
                    params: params,
                    pathURL: CommonAPI.getCampaignOrder) { (response, status, _) in
            callBack(response, status)
        }
    }
}
