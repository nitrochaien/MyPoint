//
//  CashbackDetailModel.swift
//  MyPoint
//
//  Created by Nam Vu on 7/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

struct CashbackDetailModel {

    struct Header {
        let thumbnail: String
        let brandName: String
        let point: String
        let urlString: String

        init() {
            thumbnail = ""
            brandName = "Starbucks"
            point = "87.789"
            urlString = ""
        }

        init(item: CashbackDetailItem?) {
            thumbnail = item?.brand?.logo ?? ""
            brandName = item?.brand?.brandName ?? ""
            point = Double(item?.brandTotalRewardPointCounterValue ?? 0).formattedWithSeparator
            if let url = item?.aturl, !url.isEmpty {
                let utmSource = item?.utmSource ?? ""
                let utmMedium = item?.utmMedium ?? ""
                let utmCampaign = item?.utmCampaign ?? ""
                let utmContent = item?.utmContent ?? ""
                urlString =
                "\(url)&utm_source=\(utmSource)&utm_medium=\(utmMedium)&utm_campaign=\(utmCampaign)&utm_content=\(utmContent)"
            } else {
                urlString = ""
            }
        }
    }

    struct Category: Equatable, Comparable {
        let title: String
        let percentage: String
        let percentageValue: Double

        init() {
            title = "Tiêu dùng"
            percentage = "20%"
            percentageValue = 20
        }

        init(category: CashbackDetailItemCategory?) {
            title = category?.affiliateCategoryName ?? ""
            let rewardString = category?.customerPreviewRewardValue ?? ""
            percentageValue = Double(rewardString) ?? 0
            percentage = "\(percentageValue.rounded(numberOfDecimalPlaces: 2, rule: .up).formattedWithSeparator)%"
        }

        static func ==(lhs: Category, rhs: Category) -> Bool {
            return lhs.percentageValue == rhs.percentageValue
        }

        static func >(lhs: Category, rhs: Category) -> Bool {
            return lhs.percentageValue > rhs.percentageValue
        }

        static func <(lhs: Category, rhs: Category) -> Bool {
            return lhs.percentageValue < rhs.percentageValue
        }
    }

    let header: Header
    let categories: [Category]
    let content: String

    init() {
        header = .init()
        categories = Array(repeating: .init(), count: 10)
        content = "Đây là content test"
    }

    init(item: CashbackDetailItem?) {
        header = .init(item: item)
        categories = item?.categories?.map({ category -> Category in
            return .init(category: category)
            }).sorted(by: >) ?? []
        content = "Đây là content test"
    }
}
