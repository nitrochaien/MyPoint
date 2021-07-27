//
//  NewsRequestModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - NewsResponse
struct NewsResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: NewsData?

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
struct NewsData: Codable {
    let items: [NewsItem]?
    let start, limit: String?
}

// MARK: - Item
struct NewsItem: Codable {
    let id, pageTitle, subTitle, chapeau: String?
    let thumbnail: String?
    let publishedDate: String?

    enum CodingKeys: String, CodingKey {
        case id = "page_id"
        case pageTitle = "title"
        case subTitle = "sub_title"
        case chapeau
        case thumbnail
        case publishedDate = "publish_at_date"
    }
}
