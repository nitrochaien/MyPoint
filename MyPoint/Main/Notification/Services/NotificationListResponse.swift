//
//  NotificationListResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 2/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - NotificationListResponse
struct NotificationListResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: NotificationListData?

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
struct NotificationListData: Codable {
    let start, limit: String?
    let total, unread: String?
    let listItems: [NotificationListItem]?
    let customerBalance: CustomerBalance?

    enum CodingKeys: String, CodingKey {
        case start, limit
        case total, unread
        case listItems = "list_items"
        case customerBalance = "customer_balance"
    }
}

// MARK: - ListItem
struct NotificationListItem: Codable {
    let notificationid, title, body: String?
    let clickAction: String?
    let seenAt, status, createTime: String?
    let workingSite: NotificationDetailWorkingSite?
    let clickActionParam: String?

    enum CodingKeys: String, CodingKey {
        case notificationid = "notification_id"
        case title, body
        case clickAction = "click_action_type"
        case seenAt = "seen_at"
        case status
        case clickActionParam = "click_action_param"
        case createTime = "create_time"
        case workingSite = "working_site"
    }
}

// MARK: - NotificationDetailResponse
struct NotificationDetailResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: NotificationDetailData?

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
struct NotificationDetailData: Codable {
    let notification: NotificationDetail?
}

// MARK: - Notification
struct NotificationDetail: Codable {
    let notificationid, title, body, clickActionType: String?
    let clickActionParam, seenAt, createTime: String?
    let workingSite: NotificationDetailWorkingSite?

    enum CodingKeys: String, CodingKey {
        case notificationid = "notification_id"
        case title, body
        case clickActionType = "click_action_type"
        case clickActionParam = "click_action_param"
        case seenAt = "seen_at"
        case createTime = "create_time"
        case workingSite = "working_site"
    }
}

// MARK: - WorkingSite
struct NotificationDetailWorkingSite: Codable {
    let id, name: String?
    let avatar: String?
}
