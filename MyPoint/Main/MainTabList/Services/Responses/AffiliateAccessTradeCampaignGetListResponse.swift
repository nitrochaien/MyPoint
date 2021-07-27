//
//  AffiliateAccessTradeCampaignGetListResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 7/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - AffiliateAccessTradeCampaignGetListResponse
struct AffiliateAccessTradeCampaignGetListResponse: Codable, APIHeaderResponse {
    let api, version, lang: String?
    let requestTime, responseTime: String?
    var status, errorMessage: String?
    var errorCode: String?
    var blockedReason: String?
    let data: ListCampaign?

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
struct ListCampaign: Codable {
    let listCampaign: [Campaign]?

    enum CodingKeys: String, CodingKey {
        case listCampaign = "items"
    }
}

// MARK: - Item
struct Campaign: Codable {
    let id, atCampaignID, atSaleRatio: String?
    let atStartDatetime, atEndDatetime: String?
    let atURL, merchantID, brandID, campaignPreviewRewardValue: String?
    let campaignPreviewRewardMessage, customerTotalRewardPointOnBrandCounterID: String?
    let systemTotalRewardPointOnBrandCounterID, customerTotalOrderOnBrandCounterID: String?
    let startDatetime, endDatetime: String?
    let brand: Brand?
    let customerTotalRewardPointOnBrandCounterValue, systemTotalRewardPointOnBrandCounterValue: Int?
    let customerTotalOrderOnBrandCounterValue, systemTotalOrderOnBrandCounterValue: Int?
    let brandTotalRewardPointCounterValue, brandTotalOrderCounterValue: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case atCampaignID = "at_campaign_id"
        case atSaleRatio = "at_sale_ratio"
        case atStartDatetime = "at_start_datetime"
        case atEndDatetime = "at_end_datetime"
        case atURL = "at_url"
        case merchantID = "merchant_id"
        case brandID = "brand_id"
        case campaignPreviewRewardValue = "campaign_preview_reward_value"
        case campaignPreviewRewardMessage = "campaign_preview_reward_message"
        case customerTotalRewardPointOnBrandCounterID = "customer_total_reward_point_on_brand_counter_id"
        case systemTotalRewardPointOnBrandCounterID = "system_total_reward_point_on_brand_counter_id"
        case customerTotalOrderOnBrandCounterID = "customer_total_order_on_brand_counter_id"
        case startDatetime = "start_datetime"
        case endDatetime = "end_datetime"
        case brand
        case customerTotalRewardPointOnBrandCounterValue = "customer_total_reward_point_on_brand_counter_value"
        case systemTotalRewardPointOnBrandCounterValue = "system_total_reward_point_on_brand_counter_value"
        case customerTotalOrderOnBrandCounterValue = "customer_total_order_on_brand_counter_value"
        case systemTotalOrderOnBrandCounterValue = "system_total_order_on_brand_counter_value"
        case brandTotalRewardPointCounterValue = "brand_total_reward_point_counter_value"
        case brandTotalOrderCounterValue = "brand_total_order_counter_value"
    }

    init() {
        self.id = ""
        self.atCampaignID = ""
        self.atSaleRatio = ""
        self.atStartDatetime = ""
        self.atEndDatetime = ""
        self.atURL = ""
        self.merchantID = ""
        self.brandID = ""
        self.campaignPreviewRewardValue = ""
        self.campaignPreviewRewardMessage = ""
        self.customerTotalRewardPointOnBrandCounterID = ""
        self.systemTotalRewardPointOnBrandCounterID = ""
        self.customerTotalOrderOnBrandCounterID = ""
        self.startDatetime = ""
        self.endDatetime = ""
        self.brand = Brand()
        self.customerTotalRewardPointOnBrandCounterValue = 0
        self.systemTotalRewardPointOnBrandCounterValue = 0
        self.customerTotalOrderOnBrandCounterValue = 0
        self.systemTotalOrderOnBrandCounterValue = 0
        brandTotalRewardPointCounterValue = 0
        brandTotalOrderCounterValue = 0
    }
}
