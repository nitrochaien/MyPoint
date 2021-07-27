//
//  CreateOTPResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 1/11/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

struct CreateOTPResponse: Codable, APIHeaderResponse, OTPChecker {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    var data: CreateOTPData?

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
struct CreateOTPData: Codable {
    let resendAfterSecond: Int?
    let verifyBefore, resendAfter: String?
    var remainingVerifications, unlockAfter: String?

    enum CodingKeys: String, CodingKey {
        case resendAfterSecond = "resend_after_second"
        case verifyBefore = "verify_before"
        case resendAfter = "resend_after"
        case remainingVerifications = "remaining_verifications"
        case unlockAfter = "unlock_after"
    }
}
