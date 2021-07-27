//
//  InterestedResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 1/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

struct InterestedResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: InterestedData?

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
struct InterestedData: Codable {
    let listItems: [InterestedListItem]?

    enum CodingKeys: String, CodingKey {
        case listItems = "list_items"
    }
}

// MARK: - ListItem
struct InterestedListItem: Codable {
    let id, subscribed, categoryCode, categoryName: String?
    let imageurl: String?

    enum CodingKeys: String, CodingKey {
        case id, subscribed
        case categoryCode = "category_code"
        case categoryName = "category_name"
        case imageurl = "image_url"
    }
}
