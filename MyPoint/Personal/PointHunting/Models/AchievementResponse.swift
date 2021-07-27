//
//  AchievementResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 1/21/21.
//  Copyright © 2021 NamDV. All rights reserved.
//

import Foundation

struct AchievementModel {
    let actionType: String
    let actionParam: String
    let title: String
    let content: String
    let buttonTitle: String
    let background: String
    let point: Double

    init(_ data: Achievement) {
        title = data.language?.title ?? ""
        content = data.language?.languageDescription ?? ""
        buttonTitle = data.language?.clickActionLabel ?? ""
        point = Double(data.maxRewardPoints ?? "0") ?? 0
        actionType = data.clickActionType ?? ""
        actionParam = data.clickActionParam ?? ""
        background = data.images?.first?.imageURL ?? ""
    }
}

// MARK: - AchievementResponse
struct AchievementResponse: Codable, APIHeaderResponse {
    var errorMessage, errorCode, status, blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: AchievementData?

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
struct AchievementData: Codable {
    let achievements: [Achievement]?
}

// MARK: - Achievement
struct Achievement: Codable {
    let id, achievementName: String?
    let achievementIconurl: String?
    let maxRewardPoints, clickActionType, clickActionParam, criteriaCampaignid: String?
    let achievementStatus, likeid, likeCount: String?
    let images: [Image]?
    let language: Language?
    let campaign: AchievementCampaign?

    enum CodingKeys: String, CodingKey {
        case id
        case achievementName = "achievement_name"
        case achievementIconurl = "achievement_icon_url"
        case maxRewardPoints = "max_reward_points"
        case clickActionType = "click_action_type"
        case clickActionParam = "click_action_param"
        case criteriaCampaignid = "criteria_campaign_id"
        case achievementStatus = "achievement_status"
        case likeid = "like_id"
        case likeCount = "like_count"
        case images, language
        case campaign
    }
}

// MARK: - Campaign
struct AchievementCampaign: Codable {
    let campaignName, campaignDescription, startDate, endDate: String?

    enum CodingKeys: String, CodingKey {
        case campaignName = "campaign_name"
        case campaignDescription = "campaign_description"
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

// MARK: - Language
struct Language: Codable {
    let title, languageDescription, clickActionLabel, aboutAchievementInWebsitePage: String?

    enum CodingKeys: String, CodingKey {
        case title
        case languageDescription = "description"
        case clickActionLabel = "click_action_label"
        case aboutAchievementInWebsitePage = "about_achievement_in_website_page"
    }
}
