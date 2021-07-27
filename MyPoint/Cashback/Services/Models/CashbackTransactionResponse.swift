//
//  CashbackTransactionResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 7/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - CashbackTransactionResponse
struct CashbackTransactionResponse: Codable, APIHeaderResponse {
    var blockedReason: String?
    var status, errorCode, errorMessage: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: CashbackTransactionData?

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
        case data
    }
}

// MARK: - DataClass
struct CashbackTransactionData: Codable {
    let listItems: [CashbackTransactionItem]?
    let summary: CashbackTransactionSummary?

    enum CodingKeys: String, CodingKey {
        case listItems = "list_items"
        case summary
    }
}

// MARK: - ListItem
struct CashbackTransactionItem: Codable {
    let atOrderid, atTransactionid, atQuantity, atProductPrice: String?
    let customerRewardedValue, atSalesTime, atStatus, atIsConfirmed: String?
    let customerIsRewarded: String?
    let brand: Brand?

    enum CodingKeys: String, CodingKey {
        case atOrderid = "at_order_id"
        case atTransactionid = "at_transaction_id"
        case atQuantity = "at_quantity"
        case atProductPrice = "at_product_price"
        case customerRewardedValue = "customer_rewarded_value"
        case atSalesTime = "at_sales_time"
        case atStatus = "at_status"
        case atIsConfirmed = "at_is_confirmed"
        case customerIsRewarded = "customer_is_rewarded"
        case brand
    }
}

// MARK: - Summary
struct CashbackTransactionSummary: Codable {
    let totalOrderNumber, totalRewardValue: String?

    enum CodingKeys: String, CodingKey {
        case totalOrderNumber = "total_order_number"
        case totalRewardValue = "total_reward_value"
    }
}
