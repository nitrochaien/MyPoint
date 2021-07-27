//
//  CustomerBalanceGetDetailResponse.swift
//  MyPoint
//
//  Created by Dieu on 20/03/2021.
//  Copyright © 2021 NamDV. All rights reserved.
//
import Foundation

// MARK: - MembershipPrivilegeResponse
struct CustomerBalanceGetDetailResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: CustomerBalanceDetail?

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
struct CustomerBalanceDetail: Codable {
    let primaryCurrencyPoolCode, amountTotal, amountTotalOfYear: String?
    var amountActive: String?
    var allCurrencyPools: [AllCurrencyPools]
    enum CodingKeys: String, CodingKey {
        case primaryCurrencyPoolCode = "primary_currency_pool_code"
        case amountTotal = "amount_total"
        case amountTotalOfYear = "amount_total_of_year"
        case allCurrencyPools = "all_currency_pools"
    }
}

// MARK: - Level
struct AllCurrencyPools: Codable {
    let balanceDetails: [BalanceDetails]

    enum CodingKeys: String, CodingKey {
        case balanceDetails = "balance_details"
        
    }
}

// MARK: - AccumulatedCounter
struct BalanceDetails: Codable {
    let point, startDate: String?
    var expiredDate: String?

    enum CodingKeys: String, CodingKey {
        case point
        case startDate = "start_date"
        case expiredDate = "expired_date"
    }
}
