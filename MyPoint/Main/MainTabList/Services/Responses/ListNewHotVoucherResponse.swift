//
//  ListNewHotVoucherResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 4/24/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - ListNewHotVoucherResponse
struct ListNewHotVoucherResponse: Codable, APIHeaderResponse {
    let api, version, lang: String?
    let requestTime, responseTime: String?
    var status, errorMessage: String?
    var errorCode: String?
    var blockedReason: String?
    let data: NewListHotVoucherData?

    enum CodingKeys: String, CodingKey {
        case api, version, lang
        case requestTime = "request_time"
        case responseTime = "response_time"
        case status
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case blockedReason = "blocked_reason"
        case data
    }
}

// MARK: - NewListHotVoucherData
struct NewListHotVoucherData: Codable {
    var voucherList: [HotVoucher]?
    var total: String?

    enum CodingKeys: String, CodingKey {
        case voucherList = "voucher_list"
        case total
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.voucherList = try container.decodeIfPresent([HotVoucher].self, forKey: .voucherList)
            self.total = try container.decodeIfPresent(String.self, forKey: .total)
        } catch DecodingError.typeMismatch {
            if let string = try container.decodeIfPresent(Int.self, forKey: .total) {
                self.total = "\(string)"
            }
        }
    }
}

// MARK: - VoucherList
struct NewHotVoucher: Codable {
    let id, distance, stock, voucherID: String?
    let code, name, voucherListDescription, voucherTypeCode: String?
    let voucherTypeName, voucherValue, startTime, endTime: String?
    let prices: [Price]?
    let images: [Image]?
    let category: Category?
    let catalogue: Catalogue?
    let brand: Brand?
    let likeID: String?

    enum CodingKeys: String, CodingKey {
        case id, distance, stock
        case voucherID = "voucher_id"
        case code, name
        case voucherListDescription = "description"
        case voucherTypeCode = "voucher_type_code"
        case voucherTypeName = "voucher_type_name"
        case voucherValue = "voucher_value"
        case startTime = "start_time"
        case endTime = "end_time"
        case prices, images, category, catalogue, brand
        case likeID = "like_id"
    }
}
