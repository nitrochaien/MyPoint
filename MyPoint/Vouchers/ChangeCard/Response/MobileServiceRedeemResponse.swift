//
//  MobileServiceRedeemResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 5/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - TelcoListResponse
struct MobileServiceRedeemResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: MobileServiceRedeemData?

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
        case blockedReason = "blocked_reason"
        case data
    }
}

struct MobileServiceRedeemData: Codable {
    let itemId: String?
    let customerBalance: CustomerBalance?

    enum CodingKeys: String, CodingKey {
        case itemId = "item_ids"
        case customerBalance = "customer_balance"
    }
}
