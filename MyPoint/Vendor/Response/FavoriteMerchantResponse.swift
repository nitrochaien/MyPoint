//
//  FavoriteMerchantResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 3/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - FavoriteMerchantResponse
struct FavoriteMerchantResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: FavoriteMerchantData?

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
struct FavoriteMerchantData: Codable {
    let items: [FavoriteMerchantItem]?
}

// MARK: - Item
struct FavoriteMerchantItem: Codable {
    let likeid, objectClassName, objectid, objectTitle: String?
    let objectAvatar: String?

    enum CodingKeys: String, CodingKey {
        case likeid = "like_id"
        case objectClassName = "object_class_name"
        case objectid = "object_id"
        case objectTitle = "object_title"
        case objectAvatar = "object_avatar"
    }
}
