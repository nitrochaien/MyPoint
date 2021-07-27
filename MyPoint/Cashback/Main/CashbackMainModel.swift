//
//  CashbackMainModel.swift
//  MyPoint
//
//  Created by Nam Vu on 7/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class CashbackMainModel {
    struct Header {
        let point: String

        init() {
            point = "87.987"
        }

        init(point: Int?) {
            let doubleValue = Double(point ?? 0)
            self.point = doubleValue.formattedWithSeparator
        }
    }

    struct Item {
        let thumbnail: String
        let brandName: String
        let percentage: String
        let point: String
        let id: String

        init() {
            id = ""
            thumbnail = ""
            brandName = "CỘNG CÀ PHÊ"
            percentage = "20%"
            point = "87.098"
        }

        init(campaign: Campaign) {
            id = campaign.id ?? ""
            thumbnail = campaign.brand?.logo ?? ""
            brandName = campaign.brand?.brandName ?? ""
            point = Double(campaign.brandTotalRewardPointCounterValue ?? 0).formattedWithSeparator

            let ratio = Double(campaign.atSaleRatio ?? "") ?? 0
            percentage = "\(ratio.formattedWithSeparator)%"
        }
    }

    let header: Header
    var items: [Item]

    init() {
        header = .init()
        items = Array(repeating: .init(), count: 8)
    }

    init(data: AffiliateAccessTradeCampaignGetListResponse) {
        let point = data.data?.listCampaign?.reduce(0, { (result, campaign) -> Int in
            let point = campaign.brandTotalRewardPointCounterValue ?? 0
            return result + point
        })
        header = .init(point: point)
        items = data.data?.listCampaign?.map({ campaign -> Item in
            return .init(campaign: campaign)
        }) ?? []
    }
}
