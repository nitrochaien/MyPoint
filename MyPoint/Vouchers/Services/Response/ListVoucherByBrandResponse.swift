//
//  ListVoucherByBrandResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/26/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - ListVoucherByBrandResponse
struct ListVoucherByBrandResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: VoucherList?

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

// MARK: - DataClass
struct VoucherList: Codable {
    let voucherList: [HotVoucher]?

    enum CodingKeys: String, CodingKey {
        case voucherList = "voucher_list"
    }
}
