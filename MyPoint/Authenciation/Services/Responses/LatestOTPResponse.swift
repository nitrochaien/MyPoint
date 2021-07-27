//
//  LatestOTPResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - LatestOTPResponse
struct LatestOTPResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: LatestOTPData?

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
struct LatestOTPData: Codable {
    let otpValue: OtpValue?

    enum CodingKeys: String, CodingKey {
        case otpValue = "otp_value"
    }
}

// MARK: - OtpValue
struct OtpValue: Codable {
    let id, ownerid, otpValue, idType: String?
    let timeToLiveOfOtp, mustVerifyBefore, sentTimes, remainingVerifications: String?
    let timeToResend, resendAfter, unlockAfter, timeToDoNextEvent: String?
    let mustDoNextEventBefore, nextEventName, createTime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerid = "owner_id"
        case otpValue = "otp_value"
        case idType = "id_type"
        case timeToLiveOfOtp = "time_to_live_of_otp"
        case mustVerifyBefore = "must_verify_before"
        case sentTimes = "sent_times"
        case remainingVerifications = "remaining_verifications"
        case timeToResend = "time_to_resend"
        case resendAfter = "resend_after"
        case unlockAfter = "unlock_after"
        case timeToDoNextEvent = "time_to_do_next_event"
        case mustDoNextEventBefore = "must_do_next_event_before"
        case nextEventName = "next_event_name"
        case createTime = "create_time"
    }
}
