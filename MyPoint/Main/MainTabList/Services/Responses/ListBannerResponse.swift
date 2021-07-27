//
//  ListBannerResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - ListBannerResponse
struct ListBannerResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: ListBanner?

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
struct ListBanner: Codable {
    let banners: [Banner]?
}

// MARK: - Banner
struct Banner: Codable {
    let bannerID, itemTitle: String?
    let itemImage: String?
    let clickAction, clickActionParams: String?

    enum CodingKeys: String, CodingKey {
        case bannerID = "banner_id"
        case itemTitle = "item_title"
        case itemImage = "item_image"
        case clickAction = "click_action"
        case clickActionParams = "click_action_params"
    }
}
