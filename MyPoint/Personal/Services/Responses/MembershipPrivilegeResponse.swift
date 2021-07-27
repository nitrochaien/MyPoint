//
//  MembershipPrivilegeResponse.swift
//  MyPoint
//
//  Created by Hieu on 2/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - MembershipPrivilegeResponse
struct MembershipPrivilegeResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: ListLevel?

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
struct ListLevel: Codable {
    let levels: [Level]?
}

// MARK: - Level
struct Level: Codable {
    let id, membershipLevelCode, membershipLevelRank, membershipLevelName: String?
    let membershipLevelDescription, membershipLevelContent, membershipLevelTermAndCondition: String?
    let logo: String?
    let refreshLevelAfterMonthsFromStartDate: String?
    let upgradeWhenCounterIsGreaterOrEqual: String?
    let upgradeToMembershipLevelID, downgradeLevelWhenCounterIsLessThan: String?
    let downgradeToMembershipLevelID: String?
    let images: [Image]?
    let levelStartAtDate: String?
    let accumulatedCounter: AccumulatedCounter?

    enum CodingKeys: String, CodingKey {
        case id
        case membershipLevelCode = "membership_level_code"
        case membershipLevelRank = "membership_level_rank"
        case membershipLevelName = "membership_level_name"
        case membershipLevelDescription = "membership_level_description"
        case membershipLevelContent = "membership_level_content"
        case membershipLevelTermAndCondition = "membership_level_term_and_condition"
        case logo
        case refreshLevelAfterMonthsFromStartDate = "refresh_level_after_months_from_start_date"
        case upgradeWhenCounterIsGreaterOrEqual = "upgrade_when_counter_is_greater_or_equal"
        case upgradeToMembershipLevelID = "upgrade_to_membership_level_id"
        case downgradeLevelWhenCounterIsLessThan = "downgrade_level_when_counter_is_less_than"
        case downgradeToMembershipLevelID = "downgrade_to_membership_level_id"
        case images
        case levelStartAtDate = "level_start_at_date"
        case accumulatedCounter = "accumulated_counter"
    }
  
    var upgradeWhenCounterIsGreaterOrEqualDisplay: String {
        let amount = upgradeWhenCounterIsGreaterOrEqual ?? "0"
        let doubleValue = Double(amount) ?? 0
        return String(doubleValue.formattedWithSeparator)
    }
}

// MARK: - AccumulatedCounter
struct AccumulatedCounter: Codable {
    let whatToCountCode, whatToCountName, counterValue: String?

    enum CodingKeys: String, CodingKey {
        case whatToCountCode = "what_to_count_code"
        case whatToCountName = "what_to_count_name"
        case counterValue = "counter_value"
    }
  
    var counterValueDisplay: String {
        let amount = counterValue ?? "0"
        let doubleValue = Double(amount) ?? 0
        return String(doubleValue.formattedWithSeparator)
    }
}
