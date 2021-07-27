//
//  NearbyBrandStoreResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/25/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - NearbyBrandStoreResponse
struct NearbyBrandStoreResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: ListStore?

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

struct ListStore: Codable {
    let storeList: [NearbyBrandStore]?
    let total: String?

    enum CodingKeys: String, CodingKey {
        case storeList = "store_list"
        case total
    }
}

// MARK: - NearbyBrandStore
struct NearbyBrandStore: Codable {
    let id, code, name, phone, logo: String?
    let email, fax, address, latitude: String?
    let longitude, districtCode, districtName, cityCode: String?
    let cityName, distance: String?
    let brand: Brand?
  
    var displayDistance: String? {
      let newDistance = distance ?? "0"
      let doubleValue = Double(newDistance) ?? 0
      return String(format: "%.1f km", doubleValue)
    }

    enum CodingKeys: String, CodingKey {
        case id, code, name, phone, email, fax, address, latitude, longitude, logo
        case districtCode = "district_code"
        case districtName = "district_name"
        case cityCode = "city_code"
        case cityName = "city_name"
        case distance, brand
    }
  
    init() {
      self.id = ""
      self.code = ""
      self.name = ""
      self.phone = ""
      self.logo = ""
      self.email = ""
      self.fax = ""
      self.address = ""
      self.latitude = ""
      self.longitude = ""
      self.districtCode = ""
      self.districtName = ""
      self.cityCode = ""
      self.cityName = ""
      self.distance = ""
      self.brand = Brand()
    }
}
