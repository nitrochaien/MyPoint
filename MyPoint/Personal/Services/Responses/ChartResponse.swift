//
//  ChartResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 2/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - ChartResponse
struct ChartResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: ChartData?

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
struct ChartData: Codable {
    let month: ChartMonth?
    let days: [ChartDay]?
}

// MARK: - Day
struct ChartDay: Codable {
    let summaryDate, adjustDayTotal, redeemDayTotal, rewardDayTotal: String?

    enum CodingKeys: String, CodingKey {
        case summaryDate = "summary_date"
        case adjustDayTotal = "adjust_day_total"
        case redeemDayTotal = "redeem_day_total"
        case rewardDayTotal = "reward_day_total"
    }
}

// MARK: - Month
struct ChartMonth: Codable {
    let adjustMonthTotal, redeemMonthTotal, rewardMonthTotal: String?

    enum CodingKeys: String, CodingKey {
        case adjustMonthTotal = "adjust_month_total"
        case redeemMonthTotal = "redeem_month_total"
        case rewardMonthTotal = "reward_month_total"
    }
}
