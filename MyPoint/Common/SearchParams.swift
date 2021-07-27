//
//  SearchParams.swift
//  MyPoint
//
//  Created by Nam Vu on 3/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class SearchParams {
    var brandIds: [String]
    var storeIds: [String]
    var categories: [FilterPresenter.Category]
    var catalogues: [String]
    var province: ProvinceSearchPresenter.DisplayItem
    var districtCodes: [String]
    var keywords: String
    var lat: String
    var long: String
    var distance: String
    var allowLocation: Bool
    var searchVoucher: Bool

    init() {
        brandIds = []
        storeIds = []
        categories = []
        catalogues = []
        province = .init()
        districtCodes = []
        keywords = ""
        lat = ""
        long = ""
        distance = ""
        allowLocation = false
        searchVoucher = true
    }

    func reset() {
        brandIds = []
        storeIds = []
        categories = []
        catalogues = []
        keywords = ""
        lat = ""
        long = ""
        distance = ""
        allowLocation = false
        searchVoucher = true
    }

    var isSearchingWithKeywords: Bool {
        return !keywords.isEmpty
    }

    var isFiltering: Bool {
        return !categories.isEmpty || !province.code.isEmpty || !districtCodes.isEmpty
    }

    var toParams: [String: Any] {
        var params: [String: Any] = [
            "order_direction": ListOrder.asc.rawValue
        ]

        if !brandIds.isEmpty {
            params.updateValue(brandIds.joined(separator: ","), forKey: "brand_ids")
        }
        if !storeIds.isEmpty {
            params.updateValue(storeIds.joined(separator: ","), forKey: "store_ids")
        }
        if !catalogues.isEmpty {
            params.updateValue(catalogues.joined(separator: ","), forKey: "catalogue_ids")
        }
        if !categories.isEmpty {
            let ids = categories.filter { category -> Bool in
                return category.isFiltering
            }.map { category -> String in
                return category.id
            }.joined(separator: ",")
            params.updateValue(ids, forKey: "category_ids")
        }
        if !province.code.isEmpty {
            params.updateValue(province.code, forKey: "locate_in_provinces")
        }
        if !districtCodes.isEmpty {
            let ids = districtCodes.joined(separator: ",")
            params.updateValue(ids, forKey: "locate_in_districts")
        }
        if !keywords.isEmpty {
            params.updateValue(keywords, forKey: "keywords")
        }

        var isRequestingLocation = false

        if !lat.isEmpty && allowLocation {
            isRequestingLocation = true
            params.updateValue(lat, forKey: "locate_nearest_customer_lat")
        }
        if !long.isEmpty && allowLocation {
            isRequestingLocation = true
            params.updateValue(long, forKey: "locate_nearest_customer_long")
        }
        if !distance.isEmpty {
            isRequestingLocation = true
            params.updateValue(distance, forKey: "locate_nearest_limit_distance")
        }
        if isRequestingLocation {
            if searchVoucher {
                params.updateValue("DIS", forKey: "order_by")
            } else {
                params.updateValue("DTC", forKey: "order_by")
            }
            params.updateValue("1", forKey: "locate_nearest")
        }

        return params
    }

    func removeLocationRequest() {
        lat = ""
        long = ""
        distance = ""
    }
}
