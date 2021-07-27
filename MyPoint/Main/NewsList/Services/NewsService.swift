//
//  NewsService.swift
//  MyPoint
//
//  Created by Nam Vu on 1/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class NewsService: BaseService {
    func getNewsList(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "start": String(offset),
            "limit": String(limit),
            "lang": Localize.shared.currentLanguage,
            "folder_uri": "TIN-TUC"
        ]
        requestPOST(type: NewsResponse.self,
                    params: params,
                    pathURL: CommonAPI.getNewsList) { (response, status, _) in
                        callBack(response, status)
        }
    }
}
