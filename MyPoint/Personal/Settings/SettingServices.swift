//
//  SettingServices.swift
//  MyPoint
//
//  Created by Nam Vu on 2/24/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class SettingServices: BaseService {
    func getQuestions(type: FrequencyQuestionPresenter.PageType,
                      _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "start": String(offset),
            "limit": "9999",
            "lang": Localize.shared.currentLanguage,
            "folder_uri": type.rawValue
        ]
        requestPOST(type: NewsResponse.self,
                    params: params,
                    pathURL: CommonAPI.getNewsList) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getIntroduction(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "start": String(offset),
            "limit": "9999",
            "lang": Localize.shared.currentLanguage,
            "folder_uri": "ABOUT"
        ]
        requestPOST(type: NewsResponse.self,
                    params: params,
                    pathURL: CommonAPI.getNewsList) { (response, status, _) in
                        callBack(response, status)
        }
    }
}
