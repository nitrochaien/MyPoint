//
//  RankingResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/12/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - RankingResponse
struct RankingResponse: Codable, APIHeaderResponse {
      var errorCode, errorMessage, status: String?
    var blockedReason: String?

      let api, version, lang, tzName: String?
      let tzOffset, requestTime, responseTime: String?
      let errorNumber: String?
      let data: Rank?

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
struct Rank: Codable {
    let start, limit: String?
    let customerList: [CustomerList]?

    enum CodingKeys: String, CodingKey {
        case start, limit
        case customerList = "customer_list"
    }
}

// MARK: - CustomerList
struct CustomerList: Codable {
    let ranking, customerID, membershipAccountID, membershipAccountNumber: String?
    let customerSiteID, customerFullname, customerPhone, counterValue: String?

    enum CodingKeys: String, CodingKey {
        case ranking
        case customerID = "customer_id"
        case membershipAccountID = "membership_account_id"
        case membershipAccountNumber = "membership_account_number"
        case customerSiteID = "customer_site_id"
        case customerFullname = "customer_fullname"
        case customerPhone = "customer_phone"
        case counterValue = "counter_value"
    }
}
