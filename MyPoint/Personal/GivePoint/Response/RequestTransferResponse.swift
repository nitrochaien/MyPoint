//
//  RequestTransferResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 2/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - RequestTransferResponse
struct RequestTransferResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: RequestTransferData?

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
struct RequestTransferData: Codable {
    let transferedPoints: [TransferedPoint]?
    let transactionId: String?
    let customerBalance: CustomerBalance?

    enum CodingKeys: String, CodingKey {
        case transferedPoints = "transfered_points"
        case transactionId = "transaction_id"
        case customerBalance = "customer_balance"
    }
}

// MARK: - TransferedPoint
struct TransferedPoint: Codable {
    let amount, expiredDate: String?

    enum CodingKeys: String, CodingKey {
        case amount
        case expiredDate = "expired_date"
    }
}
