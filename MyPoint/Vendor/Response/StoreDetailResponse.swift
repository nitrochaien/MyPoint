//
//  StoreDetailResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 5/25/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - StoreDetailResponse
struct StoreDetailResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: DataClass?

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
        case data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let store: Store?
}

// MARK: - Store
struct Store: Codable {
    let id, code, name, storeDescription: String?
    let logo: String?
    let phone, email, fax, address: String?
    let latitude, longitude, districtCode, districtName: String?
    let cityCode, cityName: String?
    let brand: Brand?

    enum CodingKeys: String, CodingKey {
        case id, code, name
        case storeDescription = "description"
        case logo, phone, email, fax, address, latitude, longitude
        case districtCode = "district_code"
        case districtName = "district_name"
        case cityCode = "city_code"
        case cityName = "city_name"
        case brand
    }
  
    init() {
      self.id = ""
      self.code = ""
      self.name = ""
      self.storeDescription = ""
      self.logo = ""
      self.phone = ""
      self.email = ""
      self.fax = ""
      self.address = ""
      self.latitude = ""
      self.longitude = ""
      self.districtCode = ""
      self.districtName = ""
      self.cityCode = ""
      self.cityName = ""
      self.brand = Brand()
    }
}
