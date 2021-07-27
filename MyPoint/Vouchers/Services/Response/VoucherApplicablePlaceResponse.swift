//
//  VoucherApplicablePlaceResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - VoucherApplicablePlaceResponse
struct VoucherApplicablePlaceResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: VoucherApplicablePlace?

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
struct VoucherApplicablePlace: Codable {
    let storeList: [StoreList]?

    enum CodingKeys: String, CodingKey {
        case storeList = "store_list"
    }
}

// MARK: - StoreList
struct StoreList: Codable {
    let id, code, name, phone: String?
    let email, fax, address, latitude: String?
    let longitude, districtID, districtName, cityID: String?
    let cityName, distance: String?
  
    var displayDistance: String {
        let newDistance = distance ?? "0"
        let doubleValue = Double(newDistance) ?? 0
        if doubleValue == 0 {
            return ""
        }
        return String(format: "%.1f km", doubleValue)
    }

    enum CodingKeys: String, CodingKey {
        case id, code, name, phone, email, fax, address, latitude, longitude
        case districtID = "district_id"
        case districtName = "district_name"
        case cityID = "city_id"
        case cityName = "city_name"
        case distance
    }
  
    init() {
      self.id = ""
      self.code = ""
      self.name = ""
      self.phone = ""
      self.email = ""
      self.fax = ""
      self.address = ""
      self.latitude = ""
      self.longitude = ""
      self.districtID = ""
      self.districtName = ""
      self.cityID = ""
      self.cityName = ""
      self.distance = ""
    }
}
