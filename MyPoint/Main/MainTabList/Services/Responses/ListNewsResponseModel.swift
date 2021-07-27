//
//  ListNewsResponseModel.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - ListNewsResponseModel
struct ListNewsResponseModel: Codable, APIHeaderResponse {
    let api, version, lang: String?
    var blockedReason: String?
    let requestTime, responseTime: String?
    var status, errorMessage: String?
    var errorCode: String?
    let data: DataListNews?

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

// MARK: - DataClass
struct DataListNews: Codable {
    let items: [NewsItem]?
    let start, limit: String
}
