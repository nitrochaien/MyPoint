//
//  SearchVoucherService.swift
//  MyPoint
//
//  Created by Nam Vu on 3/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class SearchVoucherService: BaseService {
    func getList(params: SearchParams,
                 _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        var reqParams: [String: Any] = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "start": offset,
            "limit": limit,
            "lang": Localize.shared.currentLanguage
        ]
        reqParams.merge(dict: params.toParams)

        requestPOST(type: SearchListResponse.self,
                    params: reqParams,
                    pathURL: CommonAPI.getSearchList) { (response, status, _) in
            callBack(response, status)
        }
    }
}

class SearchStoreService: BaseService {
    func getList(params: SearchParams,
                 _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        var reqParams: [String: Any] = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "start": offset,
            "limit": limit,
            "lang": Localize.shared.currentLanguage
        ]
        reqParams.merge(dict: params.toParams)

        requestPOST(type: NearbyBrandStoreResponse.self,
                    params: reqParams,
                    pathURL: CommonAPI.filterStores) { (response, status, _) in
            callBack(response, status)
        }
    }
}
