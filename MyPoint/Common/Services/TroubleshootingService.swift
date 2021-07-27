//
//  TroubleshootingService.swift
//  MyPoint
//
//  Created by Nam Vu on 8/12/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class TroubleshootingService: BaseService {
    func getConfig(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? ""
        ]
        requestPOST(type: TroubleshootingResponse.self,
                    params: params,
                    pathURL: CommonAPI.getTroubleshootingConfig) { (response, status, _) in
                        callBack(response, status)
        }
    }
}

// MARK: - TroubleshootingResponse
struct TroubleshootingResponse: Codable, APIHeaderResponse {
    var blockedReason: String?
    var api, errorCode, errorMessage: String?

    let version, lang, tzName: String?
    var tzOffset, requestTime, responseTime, status: String?
    let errorNumber: String?
    let data: TroubleshootingData?

    enum CodingKeys: String, CodingKey {
        case api, version, lang
        case tzName = "tz_name"
        case tzOffset = "tz_offset"
        case requestTime = "request_time"
        case responseTime = "response_time"
        case status
        case errorNumber = "error_number"
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case data
    }
}

// MARK: - DataClass
struct TroubleshootingData: Codable {
    let config: TroubleshootingConfig?
}

// MARK: - Config
struct TroubleshootingConfig: Codable {
    let developerBaseurl: String?
    let developerSiteid: String?

    enum CodingKeys: String, CodingKey {
        case developerBaseurl = "developer_base_url"
        case developerSiteid = "developer_site_id"
    }
}
