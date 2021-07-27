//
//  CheckSubmitReferenceCodeResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - CheckSubmitReferenceCodeResponse
struct CheckSubmitReferenceCodeResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: CheckSubmitReferenceCodeData?

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
struct CheckSubmitReferenceCodeData: Codable {
    let hasReferee: String?

    enum CodingKeys: String, CodingKey {
        case hasReferee = "has_referee"
    }
}
