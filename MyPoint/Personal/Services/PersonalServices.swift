//
//  PersonalServices.swift
//  MyPoint
//
//  Created by Nam Vu on 1/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class PersonalServices: BaseService {
    func updateProfile(requestModel: UpdateProfileRequestModel, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        requestPOST(type: GeneralResponse.self,
                    params: requestModel.toParams,
                    pathURL: CommonAPI.updateProfile) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func logout(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "username": storage.registeredPhoneNumber ?? "",
            "device_key": storage.deviceToken ?? "",
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: GeneralResponse.self,
                    params: params,
                    pathURL: CommonAPI.logout) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func uploadAvatar(_ image: UIImage, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        guard let imageData = image.pngData() else {
            print("Cannot parse avatar image")
            return
        }
        let imageBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        let storage = Storage.shared
        let params = [
            "worker_site_id": storage.loginData?.workerSite?.id ?? "",
            "access_token": storage.loginData?.accessToken ?? "",
            "avatar": "data:image/png;base64,\(imageBase64)",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: GeneralResponse.self,
                    params: params,
                    pathURL: CommonAPI.uploadAvatar) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getRankingAll( _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "counter_period_type": "NE",
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "start": String(offset),
            "limit": maxLimit
          ] as [String: Any]
        requestPOST(type: RankingResponse.self,
                    params: params,
                    pathURL: CommonAPI.getRank) { (response, status, _) in
                        callBack(response, status)
        }
    }
    
    func getListMembershipPrivilege(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: MembershipPrivilegeResponse.self,
                    params: params,
                    pathURL: CommonAPI.getMembershipPrivilege) { (response, status, _) in
                        callBack(response, status)
        }
    }
    func getCustomerBalanceGetDetail(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: CustomerBalanceGetDetailResponse.self,
                    params: params,
                    pathURL: CommonAPI.getCustomerBalanceGetDetail) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func checkPINValidation(_ password: String,
                            _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "password": password.sha256(),
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: PasswordCheckResponse.self,
                    params: params,
                    pathURL: CommonAPI.accountLoginForPasswordChange) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func submitReferenceCode(_ code: String,
                             _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "reference_code": code,
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "get_customer_balance": "1"
        ]
        requestPOST(type: SubmitInviteCodeResponse.self,
                    params: params,
                    pathURL: CommonAPI.submitReferenceCode) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func checkSubmitReferenceCode(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: CheckSubmitReferenceCodeResponse.self,
                    params: params,
                    pathURL: CommonAPI.checkSubmitReferenceCode) { (response, status, _) in
                        callBack(response, status)
        }
    }
    
    func getHistory(month: String,
                    type: HistoryListType,
                    year: String,
                    _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params: [String: Any] = [
            "transaction_types": type.toRequest,
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "limit": limit,
            "start": offset,
            "transaction_happened_in_year": year,
            "transaction_happened_in_month": month
        ]

        requestPOST(type: HistoryResponse.self,
                    params: params,
                    pathURL: CommonAPI.getHistory) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getChartData(month: String, year: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "year": year,
            "month": month
        ]
        requestPOST(type: ChartResponse.self,
                    params: params,
                    pathURL: CommonAPI.getChartData) { (response, status, _) in
                        callBack(response, status)
        }
    }
    
    func getListFavouriteBrand(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "object_class_name": "BRAND",
            "start": String(offset),
            "limit": String(limit)
        ]
        requestPOST(type: ListFavouriteBrandResponse.self,
                    params: params,
                    pathURL: CommonAPI.getListFavouriteVoucher) { (response, status, _) in
                        callBack(response, status)
        }
    }
    
    func getListFavouriteVoucher(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "access_token": storage.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "object_class_name": "PRODUCT_VOUCHER",
            "start": String(offset),
            "limit": String(limit)
        ]
        requestPOST(type: ListFavouriteVoucherResponse.self,
                    params: params,
                    pathURL: CommonAPI.getListFavouriteVoucher) { (response, status, _) in
                        callBack(response, status)
        }
    }
}
