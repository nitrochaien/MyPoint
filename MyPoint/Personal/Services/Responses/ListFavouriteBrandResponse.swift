//
//  ListFavouriteBrandResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 3/11/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - ListFavouriteBrandResponse
struct ListFavouriteBrandResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: ListFavouriteBrand?

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

// MARK: - ListFavouriteBrand
struct ListFavouriteBrand: Codable {
    let items: [LikedBrand]?
}

// MARK: - LikedBrand
struct LikedBrand: Codable {
    let likeID, objectClassName, objectID, objectTitle: String?
    let objectAvatar: String?
    let detail: Brand?

    enum CodingKeys: String, CodingKey {
        case likeID = "like_id"
        case objectClassName = "object_class_name"
        case objectID = "object_id"
        case objectTitle = "object_title"
        case objectAvatar = "object_avatar"
        case detail
    }
}
