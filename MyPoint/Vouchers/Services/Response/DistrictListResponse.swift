//
//  DistrictListResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 2/11/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - DistrictListResponse
struct DistrictListResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: DistrictListData?

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
struct DistrictListData: Codable {
    let listItems: [DistrictListItem]?

    enum CodingKeys: String, CodingKey {
        case listItems = "list_items"
    }
}

// MARK: - ListItem
struct DistrictListItem: Codable {
    let countryCode2, cityCode, districtCode, districtType: String?
    let districtName, districtLatitude, districtLongitude: String?

    enum CodingKeys: String, CodingKey {
        case countryCode2 = "country_code2"
        case cityCode = "city_code"
        case districtCode = "district_code"
        case districtType = "district_type"
        case districtName = "district_name"
        case districtLatitude = "district_latitude"
        case districtLongitude = "district_longitude"
    }
}
