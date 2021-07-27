//
//  MyVoucherResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 1/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - MyVoucherResponse
struct MyVoucherResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: MyVoucherData?

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
struct MyVoucherData: Codable {
    let listStart, listLimit, listTotal: Int?
    let listItems: [Voucher]?

    enum CodingKeys: String, CodingKey {
        case listStart = "list_start"
        case listLimit = "list_limit"
        case listTotal = "list_total"
        case listItems = "list_items"
    }
}

// MARK: - ListItem
struct Voucher: Codable {
    let voucherID, voucherItemID, gotTime, expiredTime: String?
    let productModelCode: String?
    let code, name, listItemDescription, voucherTypeCode: String?
    let voucherTypeName, voucherValue, startTime, endTime: String?
    let prices: [Price]?
    let images: [Image]?
    let category: Category?
    let catalogue: Catalogue?
    let brand: Brand?
    let itemMode: String?

    enum CodingKeys: String, CodingKey {
        case voucherID = "product_id"
        case voucherItemID = "product_item_id"
        case gotTime = "got_time"
        case expiredTime = "expired_time"
        case code, name
        case listItemDescription = "description"
        case voucherTypeCode = "voucher_type_code"
        case voucherTypeName = "voucher_type_name"
        case productModelCode = "product_model_code"
        case voucherValue = "voucher_value"
        case startTime = "start_time"
        case endTime = "end_time"
        case prices, images, category, catalogue, brand
        case itemMode = "import_mode"
    }
}
