//
//  ProvinceSearchResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - ProvinceSearchResponse
struct ProvinceSearchResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: ListProvince?

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
struct ListProvince: Codable {
    let listItems: [Province]?

    enum CodingKeys: String, CodingKey {
        case listItems = "list_items"
    }
}

// MARK: - ListItem
struct Province: Codable {
    let countryCode2, cityCode, cityType, cityName: String?
    let cityLatitude, cityLongitude: String?

    enum CodingKeys: String, CodingKey {
        case countryCode2 = "country_code2"
        case cityCode = "city_code"
        case cityType = "city_type"
        case cityName = "city_name"
        case cityLatitude = "city_latitude"
        case cityLongitude = "city_longitude"
    }
}
