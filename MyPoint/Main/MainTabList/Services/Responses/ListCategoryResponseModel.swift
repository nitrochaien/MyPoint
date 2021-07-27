//
//  ListCategoryResponseModel.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - CategoryVoucherResponse
struct CategoryVoucherResponse: Codable, APIHeaderResponse {
    let api, version, lang: String?
    var blockedReason: String?
    let requestTime, responseTime: String?
    var status, errorMessage: String?
    var errorCode: String?
    let data: ListCategory?

    enum CodingKeys: String, CodingKey {
        case api, version, lang
        case requestTime = "request_time"
        case responseTime = "response_time"
        case status
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case blockedReason = "blocked_reason"
        case data
    }
}

// MARK: - ListCategory
struct ListCategory: Codable {
    let listItems: [Category]?

    enum CodingKeys: String, CodingKey {
        case listItems = "list_items"
    }
}

// MARK: - Category
struct Category: Codable {
    let id, subscribed, categoryCode, categoryName: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, subscribed
        case categoryCode = "category_code"
        case categoryName = "category_name"
        case imageURL = "image_url"
    }
  
  init() {
    self.id = ""
    self.subscribed = ""
    self.categoryCode = ""
    self.categoryName = ""
    self.imageURL = ""
  }
  
  init(id: String, subscribed: String, categoryCode: String, categoryName: String, imageUrl: String) {
    self.id = id
    self.subscribed = subscribed
    self.categoryCode = categoryCode
    self.categoryName = categoryName
    self.imageURL = imageUrl
  }
}
