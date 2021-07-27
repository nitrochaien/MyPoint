//
//  GetStoreCommentsResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 5/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - GetStoreCommentsResponse
struct GetStoreCommentsResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let storeComments: StoreComments?

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
        case storeComments = "data"
    }
}

// MARK: - DataClass
struct StoreComments: Codable {
    let storeComments: [StoreComment]?
    let total: String?
  
    enum CodingKeys: String, CodingKey {
      case storeComments = "items"
      case total
    }
}

// MARK: - Item
struct StoreComment: Codable {
    let id, objectID, objectTitle: String?
    let objectAvatar: String?
    let reviewContent, reviewRating, reviewerName, reviewerCustomerID: String?
    let createTime: String?
    let reviewer: Reviewer?

    enum CodingKeys: String, CodingKey {
        case id
        case objectID = "object_id"
        case objectTitle = "object_title"
        case objectAvatar = "object_avatar"
        case reviewContent = "review_content"
        case reviewRating = "review_rating"
        case reviewerName = "reviewer_name"
        case reviewerCustomerID = "reviewer_customer_id"
        case createTime = "create_time"
        case reviewer
    }
  
    init() {
      self.id = ""
      self.objectID = ""
      self.objectTitle = ""
      self.objectAvatar = ""
      self.reviewContent = ""
      self.reviewRating = ""
      self.reviewerName = ""
      self.reviewerCustomerID = ""
      self.createTime = ""
      self.reviewer = Reviewer()
    }
}

// MARK: - Reviewer
struct Reviewer: Codable {
    let id, siteID, fullName, phone: String?
    let email, address: String?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case id
        case siteID = "site_id"
        case fullName = "full_name"
        case phone, email, address, avatar
    }
  
    init() {
      self.id = ""
      self.siteID = ""
      self.fullName = ""
      self.phone = ""
      self.email = ""
      self.address = ""
      self.avatar = ""
    }
}
