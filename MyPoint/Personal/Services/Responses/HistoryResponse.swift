//
//  HistoryResponse.swift
//  MyPoint
//
//  Created by Hieu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - HistoryResponse
struct HistoryResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: ListHistory?

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
struct ListHistory: Codable {
    let history: [History]?
}

// MARK: - History
struct History: Codable {
    let transactionSequenceID, transactionTag, transactionDatetime, currencyCode: String?
    let transactionTagDescription: String?
    let poolID, poolCode, brandID, brandCode: String?
    let brandName, invoiceNumber, adjustTotal, redeemTotal: String?
    let transactionType: String?
    let brandLogo: String?
    let rewardTotal: String?

    enum CodingKeys: String, CodingKey {
        case transactionSequenceID = "transaction_sequence_id"
        case transactionTag = "transaction_tag"
        case transactionDatetime = "transaction_datetime"
        case currencyCode = "currency_code"
        case poolID = "pool_id"
        case poolCode = "pool_code"
        case brandID = "brand_id"
        case brandCode = "brand_code"
        case brandName = "brand_name"
        case invoiceNumber = "invoice_number"
        case adjustTotal = "adjust_total"
        case redeemTotal = "redeem_total"
        case rewardTotal = "reward_total"
        case brandLogo = "brand_logo"
        case transactionType = "transaction_type"
        case transactionTagDescription = "transaction_tag_description"
    }

    var displayName: String? {
        return brandName?.isEmpty == true ? "invite.app".localized : brandName
    }
  
    var transactionTime: Date {
      let date = transactionDatetime?.toDate() ?? Date()
      return date
    }
  
    var transctionDate: String {
        let value = transactionDatetime?.dateToString(fromFormat: DateFormat.server, DateFormat.chart) ?? ""
        return value.capitalizingFirstLetter()
    }

    var pointValue: Double {
        let redeem = Double(redeemTotal ?? "") ?? 0
        let reward = Double(rewardTotal ?? "") ?? 0
        let adjust = Double(adjustTotal ?? "") ?? 0
        return reward - redeem + adjust
    }

    var pointDisplay: (String, String) {
        if pointValue >= 0 {
            return ("+\(pointValue.formattedWithSeparator)", "#21C777")
        }
        return ("\(pointValue.formattedWithSeparator)", "#FE515A")
    }

    var dateDisplay: String? {
        return transactionDatetime?.dateToString(fromFormat: DateFormat.server, DateFormat.history)
    }
}
