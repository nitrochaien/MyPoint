//
//  MainServices.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

final class MainServices: BaseService {

    func getListHotVoucher(requestModel: ListHotVoucherRequestModel, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "catalogue_codes": "HOT",
            "start": offset,
            "limit": limit
            ] as [String: Any]
        requestPOST(type: ListNewHotVoucherResponse.self, params: params, pathURL: CommonAPI.getSearchList) { (response, status, _) in
            callBack(response, status)
        }
    }
  
    func getListHotVoucherByCategories(categoryId: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "catalogue_codes": "HOT",
            "category_ids": categoryId,
            "start": offset,
            "limit": limit
            ] as [String: Any]
        requestPOST(type: ListNewHotVoucherResponse.self, params: params, pathURL: CommonAPI.getSearchList) { (response, status, _) in
            callBack(response, status)
        }
    }

    func getListSearchHotVoucher(keyWords: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "keywords": keyWords,
            "start": offset,
            "limit": limit
            ] as [String: Any]
        requestPOST(type: ListHotVoucherResponse.self, params: params, pathURL: CommonAPI.listHotVoucher) { (response, status, _) in
            callBack(response, status)
        }
    }

    func getListCategory(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? ""
        ]
        requestPOST(type: CategoryVoucherResponse.self, params: params, pathURL: CommonAPI.listCategory) { (response, status, _) in
            callBack(response, status)
        }
    }

    func getListBrand(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "start": offset,
            "limit": limit
            ] as [String: Any]
        requestPOST(type: ListBrandResponseModel.self,
                    params: params,
                    pathURL: CommonAPI.listBiggestBrand) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getListNews(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "limit": "5",
            "start": "0",
            "folder_uri": "TIN-TUC"
        ]
        requestPOST(type: ListNewsResponseModel.self, params: params, pathURL: CommonAPI.getNewsList) { (response, status, _) in
            callBack(response, status)
        }
    }

    func getListProvinces(countryCode: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = ["access_token": Storage.shared.loginData?.accessToken ?? "",
                      "country_code2": countryCode,
                      "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: ProvinceSearchResponse.self,
                    params: params,
                    pathURL: CommonAPI.listProvince) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getListDistrict(provinceCode: String,
                         _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "province_code": provinceCode,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: DistrictListResponse.self,
                    params: params,
                    pathURL: CommonAPI.listDistrict) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getPageData(pageId: String,
                     _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "website_page_id": pageId,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: PageDetailResponse.self,
                    params: params,
                    pathURL: CommonAPI.getPageDetail) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getListBanner(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "position_code": "MOBILE_TOP_BANNERS"
        ]
        requestPOST(type: ListBannerResponse.self, params: params, pathURL: CommonAPI.getBanner) { (response, status, _) in
            callBack(response, status)
        }
    }

    func updateNotificationToken(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "push_notification_token": storage.firebaseToken ?? "",
            "hardware_type": isPhone ? "Mobile" : "Tablet",
            "hardware_model": UIDevice.current.type.rawValue,
            "operating_system": "iOS",
            "software_type": "Application",
            "software_model": "MyPoint",
            "layout_engine": String(format: "Version %@, build %@", version, build),
            "user_device_name": UIDevice.current.name
        ]
        requestPOST(type: GeneralResponse.self,
                    params: params,
                    pathURL: CommonAPI.updatePushNotificationToken ) { (response, status, _) in
                        callBack(response, status)
        }
    }
  
    func getListCampain(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "start": offset,
            "limit": limit
            ] as [String: Any]
        requestPOST(type: AffiliateAccessTradeCampaignGetListResponse.self, params: params, pathURL: CommonAPI.getCampaign) { (response, status, _) in
            callBack(response, status)
        }
    }
}
