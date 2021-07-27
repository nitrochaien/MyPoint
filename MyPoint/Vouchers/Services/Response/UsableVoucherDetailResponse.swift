//
//  UsableVoucherDetailResponse.swift
//  MyPoint
//
//  Created by Hieu on 2/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - UsableVoucherDetailResponse
struct UsableVoucherDetailResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: UsableItem?

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

struct UsableItem: Codable {
    let item: UsableVoucher?
}

// MARK: - DataClass
struct UsableVoucher: Codable {
    let voucherID, voucherItemID, actionTime, code: String?
    let serial, name, dataDescription: String?
    let category: Category?
    let catalogue: Catalogue?
    let voucherTypeCode, voucherTypeName, voucherValue: String?
    let voucherContent, voucherTermAndCondition, voucherStockRemark, expiredTime: String?
    let statusCode, status, beneficiarySiteName: String?
    let prices: [Price]?
    let images: [Image]?
    let brand: Brand?
    let likeId: String?
    let codeSecret: String?

    enum CodingKeys: String, CodingKey {
        case voucherID = "voucher_id"
        case voucherItemID = "product_item_id"
        case actionTime = "action_time"
        case code, serial, name
        case dataDescription = "description"
        case category, catalogue
        case voucherTypeCode = "voucher_type_code"
        case voucherTypeName = "voucher_type_name"
        case voucherValue = "voucher_value"
        case voucherContent = "content"
        case voucherTermAndCondition = "term_and_condition"
        case voucherStockRemark = "voucher_stock_remark"
        case expiredTime = "expired_time"
        case statusCode = "status_code"
        case status
        case beneficiarySiteName = "beneficiary_site_name"
        case prices, images, brand
        case likeId = "like_id"
        case codeSecret = "code_secret"
    }
}
