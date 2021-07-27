//
//  CashbackDetailResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 7/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - CashbackDetailResponse
struct CashbackDetailResponse: Codable, APIHeaderResponse {
    var blockedReason: String?
    var status, errorCode, errorMessage: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: CashbackDetailData?

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
struct CashbackDetailData: Codable {
    let item: CashbackDetailItem?
}

// MARK: - DataItem
struct CashbackDetailItem: Codable {
    let id, atCampaignid, atSaleRatio, atStartDatetime: String?
    let atEndDatetime, aturl, merchantid, brandid: String?
    let campaignPreviewRewardValue, campaignPreviewRewardMessage: String?
    let customerTotalRewardPointOnBrandCounterid, systemTotalRewardPointOnBrandCounterid: String?
    let customerTotalOrderOnBrandCounterid, startDatetime, endDatetime: String?
    let brand: Brand?
    let brandTotalRewardPointCounterValue, brandTotalOrderCounterValue: Int?
    let brandPageAbout: Page?
    let categories: [CashbackDetailItemCategory]?
    let utmSource, utmCampaign, utmContent, utmMedium: String?

    enum CodingKeys: String, CodingKey {
        case id
        case atCampaignid = "at_campaign_id"
        case atSaleRatio = "at_sale_ratio"
        case atStartDatetime = "at_start_datetime"
        case atEndDatetime = "at_end_datetime"
        case aturl = "at_url"
        case merchantid = "merchant_id"
        case brandid = "brand_id"
        case campaignPreviewRewardValue = "campaign_preview_reward_value"
        case campaignPreviewRewardMessage = "campaign_preview_reward_message"
        case customerTotalRewardPointOnBrandCounterid = "customer_total_reward_point_on_brand_counter_id"
        case systemTotalRewardPointOnBrandCounterid = "system_total_reward_point_on_brand_counter_id"
        case customerTotalOrderOnBrandCounterid = "customer_total_order_on_brand_counter_id"
        case startDatetime = "start_datetime"
        case endDatetime = "end_datetime"
        case brand
        case brandTotalRewardPointCounterValue = "brand_total_reward_point_counter_value"
        case brandTotalOrderCounterValue = "brand_total_order_counter_value"
        case brandPageAbout = "brand_page_about"
        case categories = "category"
        case utmCampaign = "utm_campaign"
        case utmContent = "utm_content"
        case utmMedium = "utm_medium"
        case utmSource = "utm_source"
    }
}

// MARK: - CategoryElement
struct CashbackDetailItemCategory: Codable {
    let affiliateCategoryName, atProductCategoryid: String?
    let customerPreviewRewardType, customerPreviewRewardValue: String?

    enum CodingKeys: String, CodingKey {
        case affiliateCategoryName = "affiliate_category_name"
        case atProductCategoryid = "at_product_category_id"
        case customerPreviewRewardType = "customer_preview_reward_type"
        case customerPreviewRewardValue = "customer_preview_reward_value"
    }
}
