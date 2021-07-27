//
//  SubmitStoreCommentResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 5/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - Response
struct SubmitStoreCommentResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: SubmitStoreComment?

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
struct SubmitStoreComment: Codable {
}

struct Review {
  var rate: String?
  var review: String?
  
  init() {
    self.rate = ""
    self.review = ""
  }
  
  init(rate: Double, review: String) {
    self.rate = "\(rate)"
    self.review = review
  }
}
