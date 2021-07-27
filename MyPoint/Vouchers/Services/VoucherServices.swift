//
//  VoucherServices.swift
//  MyPoint
//
//  Created by Nam Vu on 1/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class VoucherServices: BaseService {
    func getUsedVoucherList(ordered: ListOrder,
                            _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "list_start": String(offset),
            "list_limit": String(limit),
            "list_order": ordered.rawValue,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: MyVoucherResponse.self,
                    params: params,
                    pathURL: CommonAPI.getUsedVoucherList) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getWaitingVoucherList(ordered: ListOrder,
                               brandId: String,
                               _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        var params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "list_start": String(offset),
            "list_limit": String(limit),
            "list_order": ordered.rawValue,
            "lang": Localize.shared.currentLanguage
        ]

        if !brandId.isEmpty {
            params.updateValue(brandId, forKey: "brand_id")
        }

        requestPOST(type: MyVoucherResponse.self,
                    params: params,
                    pathURL: CommonAPI.getWaitingVoucherList) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getExpiredVoucherList(ordered: ListOrder,
                               _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "list_start": String(offset),
            "list_limit": String(limit),
            "list_order": ordered.rawValue,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: MyVoucherResponse.self,
                    params: params,
                    pathURL: CommonAPI.getExpiredVoucherList) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getMyVoucherBrandWaitingList(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: BrandWaitingListResponse.self,
                    params: params,
                    pathURL: CommonAPI.getMyVoucherBrandWaitingList) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func requestCategoryList(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: InterestedResponse.self,
                    params: params,
                    pathURL: CommonAPI.getAllCategories) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func requestCustomerBalance(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: CustomerBalanceResponse.self,
                    params: params,
                    pathURL: CommonAPI.getCustomerBalance) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getVoucherDetail(voucherId: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "voucher_id": voucherId,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: VoucherDetailResponse.self,
                    params: params,
                    pathURL: CommonAPI.getVoucherDetail) { (response, status, _) in
                        callBack(response, status)
        }
    }
    
    func getUsableVoucherDetail(voucherId: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "product_item_id": voucherId,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: UsableVoucherDetailResponse.self,
                    params: params,
                    pathURL: CommonAPI.getUsableVoucherDetail) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getVoucherApplicablePlace(voucherId: String, lat: String, long: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "product_id": voucherId,
            "lang": Localize.shared.currentLanguage,
            "locate_nearest_customer_lat": lat,
            "locate_nearest_customer_long": long,
            "locate_nearest": "1"
        ]
        requestPOST(type: VoucherApplicablePlaceResponse.self,
                    params: params,
                    pathURL: CommonAPI.getVoucherApplicablePlace) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getListVoucherByCategories(categoryCode: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = ["access_token": Storage.shared.loginData?.accessToken ?? "",
                      "category_code": categoryCode,
                      "lang": Localize.shared.currentLanguage,
                      "limit": String(limit),
                      "start": String(offset)
        ]
        requestPOST(type: ListHotVoucherResponse.self,
                    params: params,
                    pathURL: CommonAPI.getListVoucherByCategory) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func rateTransaction(requestModel: RatingPresenter.RatingRequestModel,
                         _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        requestPOST(type: GeneralResponse.self,
                    params: requestModel.toParams,
                    pathURL: CommonAPI.requestTransactionReview) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getListVoucherByBrand(brandId: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = ["access_token": Storage.shared.loginData?.accessToken ?? "",
                      "brand_ids": brandId,
                      "lang": Localize.shared.currentLanguage,
                      "limit": String(limit),
                      "start": String(offset)
        ]
        requestPOST(type: ListVoucherByBrandResponse.self,
                    params: params,
                    pathURL: CommonAPI.voucherBrand) { (response, status, _) in
                        callBack(response, status)
        }
    }
  
    func getListAllVoucherByBrand(brandId: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = ["access_token": Storage.shared.loginData?.accessToken ?? "",
                      "brand_ids": brandId,
                      "lang": Localize.shared.currentLanguage,
                      "limit": String(maxLimit),
                      "start": String(offset)
        ]
        requestPOST(type: ListVoucherByBrandResponse.self,
                    params: params,
                    pathURL: CommonAPI.voucherBrand) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func redeemVoucher(voucherId: String,
                       messageContent: String = "", _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = ["access_token": Storage.shared.loginData?.accessToken ?? "",
                      "product_id": voucherId,
                      "quantity": "1",
                      "get_customer_balance": "1",
                      "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: RedeemVoucherResponse.self,
                    params: params,
                    pathURL: CommonAPI.redeemVoucher,
                    messageContent: messageContent
                    ) { (response, status, _) in
                        callBack(response, status)
        }

    }
    func redeemMyVoucher(voucherId: String,
                         _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "product_item_id": voucherId,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: MyVoucherRedeemResponse.self,
                    params: params,
                    pathURL: CommonAPI.myVoucherRedeem
        ) { (response, status, _) in
                        callBack(response, status)
        }
    }
  
      func likeBrand(voucherId: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
          let params = [
              "access_token": Storage.shared.loginData?.accessToken ?? "",
              "lang": Localize.shared.currentLanguage,
              "object_class_name": "PRODUCT_VOUCHER",
              "object_id": voucherId
              ] as [String: Any]
          requestPOST(type: LikeBrandResponse.self,
                      params: params,
                      pathURL: CommonAPI.likeBrand) { (response, status, _) in
                          callBack(response, status)
          }
      }
    
      func unLikeBrand(likeId: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
          let params = [
              "access_token": Storage.shared.loginData?.accessToken ?? "",
              "lang": Localize.shared.currentLanguage,
              "like_id": likeId
              ] as [String: Any]
          requestPOST(type: UnLikeBrandResponse.self,
                      params: params,
                      pathURL: CommonAPI.unlikeBrand) { (response, status, _) in
                          callBack(response, status)
          }
      }
    
    func getList( _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let reqParams: [String: Any] = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "start": offset,
            "limit": limit,
            "lang": Localize.shared.currentLanguage
        ]

        requestPOST(type: SearchListResponse.self,
                    params: reqParams,
                    pathURL: CommonAPI.getSearchList) { (response, status, _) in
            callBack(response, status)
        }
    }

    func markVoucherAsUsed(voucherId: String,
                           _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let reqParams: [String: Any] = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "product_item_id": voucherId,
            "lang": Localize.shared.currentLanguage
        ]

        requestPOST(type: GeneralResponse.self,
                    params: reqParams,
                    pathURL: CommonAPI.markVoucherAsUsed) { (response, status, _) in
            callBack(response, status)
        }
    }

    func markVoucherAsUnused(voucherId: String,
                             _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let reqParams: [String: Any] = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "product_item_id": voucherId,
            "lang": Localize.shared.currentLanguage
        ]

        requestPOST(type: GeneralResponse.self,
                    params: reqParams,
                    pathURL: CommonAPI.markVoucherAsUnused) { (response, status, _) in
            callBack(response, status)
        }
    }
}

// MARK: - MyVoucherRedeemResponse
struct MyVoucherRedeemResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: MyVoucherRedeemData?

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
struct MyVoucherRedeemData: Codable {
    let voucherCode: String?

    enum CodingKeys: String, CodingKey {
        case voucherCode = "voucher_code"
    }
}
