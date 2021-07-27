//
//  MerchantServices.swift
//  MyPoint
//
//  Created by Nam Vu on 2/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

final class MerchantServices: BaseService {
    func getAllBrands(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
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

    func getNewestBrands(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "start": offset,
            "limit": limit
            ] as [String: Any]
        requestPOST(type: ListBrandResponseModel.self,
                    params: params,
                    pathURL: CommonAPI.listBrand) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getListAllBrands(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
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
    
    func getListLastestBrands(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "start": String(offset),
            "limit": String(limit)
            ] as [String: Any]
        requestPOST(type: ListBrandResponseModel.self,
                    params: params,
                    pathURL: CommonAPI.listBrand) { (response, status, _) in
                        callBack(response, status)
        }
    }
  
    func getListAllNearbyStoresBrand(brandId: String, lat: String, long: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "start": offset,
            "limit": limit,
            "locate_nearest_customer_lat": lat,
            "locate_nearest_customer_long": long,
            "locate_nearest": "1",
            //            "locate_nearest_limit_distance": "99999",
            "order_by": "DTC",
            "brand_ids": brandId
            ] as [String: Any]
        requestPOST(type: NearbyBrandStoreResponse.self,
                    params: params,
                    pathURL: CommonAPI.listNearbyBrandStore) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getListNearbyStoresBrand(brandId: String, lat: String, long: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "start": String(offset),
            "limit": String(limit),
            "locate_nearest_customer_lat": lat,
            "locate_nearest_customer_long": long,
            "locate_nearest": "1",
            //            "locate_nearest_limit_distance": "99999",
            "order_by": "DTC",
            "brand_ids": brandId
            ] as [String: Any]
        requestPOST(type: NearbyBrandStoreResponse.self,
                    params: params,
                    pathURL: CommonAPI.listNearbyBrandStore) { (response, status, _) in
                        callBack(response, status)
        }
    }
  
    func getListNearbyStoresBrand(categoryIds: String, lat: String, long: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "start": String(offset),
            "limit": String(limit),
            "locate_nearest_customer_lat": lat,
            "locate_nearest_customer_long": long,
            "locate_nearest": "1",
            //            "locate_nearest_limit_distance": "99999",
            "order_by": "DTC",
            "category_ids": categoryIds
            ] as [String: Any]
        requestPOST(type: NearbyBrandStoreResponse.self,
                    params: params,
                    pathURL: CommonAPI.listNearbyBrandStore) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getListFavouriteStoresBrand(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "start": offset,
            "limit": limit,
            "object_class_name": "BRAND"
            ] as [String: Any]
        requestPOST(type: FavoriteMerchantResponse.self,
                    params: params,
                    pathURL: CommonAPI.listFavouriteBrand) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getBrandDetail(brandId: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "brand_id": brandId
            ] as [String: Any]
        requestPOST(type: BrandDetailResponse.self,
                    params: params,
                    pathURL: CommonAPI.brandDetail) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func likeBrand(brandId: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "object_class_name": "BRAND",
            "object_id": brandId
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
  
    func getStoreDetail(storeId: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
      let params = [
        "access_token": Storage.shared.loginData?.accessToken ?? "",
        "store_id": storeId
      ] as [String: Any]
      requestPOST(type: StoreDetailResponse.self,
      params: params,
      pathURL: CommonAPI.getStoreDetail) { (response, status, _) in
          callBack(response, status)
      }
    }
  
    func getStoreComments(storeId: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
      let params = [
        "access_token": Storage.shared.loginData?.accessToken ?? "",
        "lang": Localize.shared.currentLanguage,
        "object_class_name": "STORE",
        "object_id": storeId,
        "start": "0",
        "limit": "5",
        "show_order_direction": "0"
      ] as [String: Any]
      requestPOST(type: GetStoreCommentsResponse.self,
      params: params,
      pathURL: CommonAPI.getStoreComments) { (response, status, _) in
          callBack(response, status)
      }
    }
  
  func submitStoreComment(storeId: String, reviewContent: String, reviewRating: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
      let params = [
        "access_token": Storage.shared.loginData?.accessToken ?? "",
        "lang": Localize.shared.currentLanguage,
        "object_class_name": "STORE",
        "object_id": storeId,
        "review_content": reviewContent,
        "review_rating": reviewRating
      ] as [String: Any]
      requestPOST(type: SubmitStoreCommentResponse.self,
      params: params,
      pathURL: CommonAPI.submitStoreComment) { (response, status, _) in
          callBack(response, status)
      }
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
