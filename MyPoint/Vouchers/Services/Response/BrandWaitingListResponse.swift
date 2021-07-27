//
//  BrandWaitingListResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 1/31/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - BrandWaitingListResponse
struct BrandWaitingListResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: BrandWaitingData?

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
struct BrandWaitingData: Codable {
    let items: [BrandWaitingItem]?
}

// MARK: - Item
struct BrandWaitingItem: Codable {
    let brandid, voucherCount, organizationid, organizationCode: String?
    let organizationName, brandCode, brandName: String?
    let category: BrandWaitingCategory?
    let logo: String?
    let images: [BrandWaitingImage]?

    enum CodingKeys: String, CodingKey {
        case brandid = "brand_id"
        case voucherCount = "voucher_count"
        case organizationid = "organization_id"
        case organizationCode = "organization_code"
        case organizationName = "organization_name"
        case brandCode = "brand_code"
        case brandName = "brand_name"
        case category, logo, images
    }
}

// MARK: - Category
struct BrandWaitingCategory: Codable {
    let id, categoryCode, categoryName: String?
    let imageurl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryCode = "category_code"
        case categoryName = "category_name"
        case imageurl = "image_url"
    }
}

// MARK: - Image
struct BrandWaitingImage: Codable {
    let id, type, caption: String?
    let imageurl: String?

    enum CodingKeys: String, CodingKey {
        case id, type, caption
        case imageurl = "image_url"
    }
}
