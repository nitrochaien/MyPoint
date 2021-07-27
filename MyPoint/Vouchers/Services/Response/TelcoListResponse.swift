//
//  TelcoListResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 4/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - TelcoListResponse
struct TelcoListResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: TelcoListData?

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
struct TelcoListData: Codable {
    let products: [TelcoProduct]?
}

// MARK: - Product
struct TelcoProduct: Codable {
    let id, productModelCode, code, name: String?
    let productDescription: String?
    let startTime, endTime: String?
    let limitQuantityPerTransaction, brandid, brandCode, brandName: String?
    let brandLogo: String?
    let images: [TelcoImage]?
    let language: TelcoLanguage?
    let prices: [TelcoPrice]?

    enum CodingKeys: String, CodingKey {
        case id
        case productModelCode = "product_model_code"
        case code, name
        case productDescription = "description"
        case startTime = "start_time"
        case endTime = "end_time"
        case limitQuantityPerTransaction = "limit_quantity_per_transaction"
        case brandid = "brand_id"
        case brandCode = "brand_code"
        case brandName = "brand_name"
        case brandLogo = "brand_logo"
        case images, language, prices
    }
}

// MARK: - Image
struct TelcoImage: Codable {
    let id, caption: String?
    let imageurl: String?

    enum CodingKeys: String, CodingKey {
        case id, caption
        case imageurl = "image_url"
    }
}

// MARK: - Language
struct TelcoLanguage: Codable {
    let content, termAndCondition, stockRemark: String?

    enum CodingKeys: String, CodingKey {
        case content
        case termAndCondition = "term_and_condition"
        case stockRemark = "stock_remark"
    }
}

// MARK: - Price
struct TelcoPrice: Codable {
    let channelCode, channelName, payPoint, originalPrice: String?
    let poolCode, subPoolCode, currencyCode: String?

    enum CodingKeys: String, CodingKey {
        case channelCode = "channel_code"
        case channelName = "channel_name"
        case payPoint = "pay_point"
        case originalPrice = "original_price"
        case poolCode = "pool_code"
        case subPoolCode = "sub_pool_code"
        case currencyCode = "currency_code"
    }
}
