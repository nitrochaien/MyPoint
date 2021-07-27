//
//  SearchListResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 3/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - ListHotVoucherResponse
struct SearchListResponse: Codable, APIHeaderResponse {
    let api, version, lang: String?
    var blockedReason: String?
    let requestTime, responseTime: String?
    var status, errorMessage: String?
    var errorCode: String?
    let data: SearchListData?

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

// MARK: - DataClass
struct SearchListData: Codable {
    var listItems: [HotVoucher]?
    var total: String?

    enum CodingKeys: String, CodingKey {
        case listItems = "voucher_list"
        case total
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.listItems = try container.decodeIfPresent([HotVoucher].self, forKey: .listItems)
            self.total = try container.decodeIfPresent(String.self, forKey: .total)
        } catch DecodingError.typeMismatch {
            if let string = try container.decodeIfPresent(Int.self, forKey: .total) {
                self.total = "\(string)"
            }
        }
    }
}
