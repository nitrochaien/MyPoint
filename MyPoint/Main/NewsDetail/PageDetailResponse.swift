//
//  NewsDetailResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 2/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - PageDetailResponse
struct PageDetailResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: PageDetailData?

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
struct PageDetailData: Codable {
    let pageDetail: Page?

    enum CodingKeys: String, CodingKey {
        case pageDetail = "page_detail"
    }
}

// MARK: - Item
struct Item: Codable {
    let contentText: String?
    let mediaType: String?
    let contentCaption: String?
    let showOrder: String?
    let pages: [Page]?

    enum CodingKeys: String, CodingKey {
        case contentText = "content_text"
        case mediaType = "media_type"
        case contentCaption = "content_caption"
        case showOrder = "show_order"
        case pages
    }
}

// MARK: - Page
struct Page: Codable {
    let pageid, title, subTitle, chapeau: String?
    let thumbnail: String?
    let publishAtDate: String?
    let items: [Item]?

    enum CodingKeys: String, CodingKey {
        case pageid = "page_id"
        case title
        case subTitle = "sub_title"
        case chapeau, thumbnail
        case publishAtDate = "publish_at_date"
        case items
    }
  
    init() {
      self.pageid = ""
      self.title = ""
      self.subTitle = ""
      self.chapeau = ""
      self.thumbnail = ""
      self.publishAtDate = ""
      self.items = []
    }

    var isNull: Bool {
        return pageid == nil && title == nil && subTitle == nil && chapeau == nil
        && thumbnail == nil && publishAtDate == nil && items == nil
    }
}
