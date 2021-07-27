//
//  OneTimeCodeResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 5/6/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - OneTimeCodeResponse
struct OneTimeCodeResponse: Codable, APIHeaderResponse {
    var blockedReason: String?
    var status, errorCode, errorMessage: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: OneTimeCodeData?

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
struct OneTimeCodeData: Codable {
    let oneTimeNumber: String?

    enum CodingKeys: String, CodingKey {
        case oneTimeNumber = "one_time_number"
    }
}
