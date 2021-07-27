//
//  CheckTransferPasswordResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 2/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - CheckTransferPasswordResponse
struct CheckTransferPasswordResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: CheckTransferPasswordData?

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
struct CheckTransferPasswordData: Codable {
    let timeToTransferPoint, transferPointBefore, remainingVerifications, unlockAfter: String?

    enum CodingKeys: String, CodingKey {
        case timeToTransferPoint = "time_to_transfer_point"
        case transferPointBefore = "transfer_point_before"
        case remainingVerifications = "remaining_verifications"
        case unlockAfter = "unlock_after"
    }
}
