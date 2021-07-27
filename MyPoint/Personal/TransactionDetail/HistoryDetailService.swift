//
//  HistoryDetailService.swift
//  MyPoint
//
//  Created by Nam Vu on 3/12/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class HistoryDetailService: BaseService {

    func getDetail(id: String,
                   _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "transaction_sequence_id": id
        ]

        requestPOST(type: HistoryDetailResponse.self,
                    params: params,
                    pathURL: CommonAPI.getHistoryDetail) { (response, status, _) in
                        callBack(response, status)
        }
    }
}

// MARK: - HistoryDetailResponse
struct HistoryDetailResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: HistoryDetailData?

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
struct HistoryDetailData: Codable {
    let info: HistoryDetailInfo?
}

// MARK: - Info
struct HistoryDetailInfo: Codable {
    let transactionSequenceid, transactionTag, transactionDatetime, currencyCode: String?
    let transactionTagDescription: String?
    let poolid, poolCode, brandid, brandCode: String?
    let brandName: String?
    let brandLogo: String?
    let invoiceNumber, productid, productModelCode, productModelName: String?
    let productItemids, adjustTotal, redeemTotal, rewardTotal: String?

    enum CodingKeys: String, CodingKey {
        case transactionSequenceid = "transaction_sequence_id"
        case transactionTag = "transaction_tag"
        case transactionDatetime = "transaction_datetime"
        case currencyCode = "currency_code"
        case poolid = "pool_id"
        case poolCode = "pool_code"
        case brandid = "brand_id"
        case brandCode = "brand_code"
        case brandName = "brand_name"
        case brandLogo = "brand_logo"
        case invoiceNumber = "invoice_number"
        case productid = "product_id"
        case productModelCode = "product_model_code"
        case productModelName = "product_model_name"
        case productItemids = "product_item_ids"
        case adjustTotal = "adjust_total"
        case redeemTotal = "redeem_total"
        case rewardTotal = "reward_total"
        case transactionTagDescription = "transaction_tag_description"
    }
}
