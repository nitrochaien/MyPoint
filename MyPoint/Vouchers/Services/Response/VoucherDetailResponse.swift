//
//  VoucherDetailResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - VoucherDetailResponseModel
struct VoucherDetailResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: VoucherDetail?

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
struct VoucherDetail: Codable {
    let voucherID, code, name, dataDescription: String?
    let voucherTypeCode, voucherTypeName, voucherValue, voucherContent: String?
    let termAndCondition, voucherTermAndCondition, voucherStockRemark, startTime, endTime: String?
    let prices: [Price]?
    let images: [Image]?
    let category: Category?
    let catalogue: Catalogue?
    let brand: Brand?
    let likeId: String?
    let stock: String?
    let itemMode: String?

    enum CodingKeys: String, CodingKey {
        case voucherID = "voucher_id"
        case code, name
        case dataDescription = "description"
        case voucherTypeCode = "voucher_type_code"
        case voucherTypeName = "voucher_type_name"
        case voucherValue = "voucher_value"
        case voucherContent = "voucher_content"
        case termAndCondition = "term_and_condition"
        case voucherTermAndCondition = "voucher_term_and_condition"
        case voucherStockRemark = "stock_remark"
        case startTime = "start_time"
        case endTime = "end_time"
        case prices, images, category, catalogue, brand
        case likeId = "like_id"
        case stock
        case itemMode = "import_mode"
    }
    
    var amount: Int {
      return Int(stock ?? "0") ?? 0
    }
}
