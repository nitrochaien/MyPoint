//
//  MyVoucherModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

struct MyVoucherModel {
    enum VoucherType {
        case readyToUse, used, outdate
    }

    let image: String
    let title: String
    let deadline: String
    let type: VoucherType
    let expiredDate: Date?
    let id: String
    let itemId: String
    let isMobileCard: Bool

    init(with response: Voucher, type: VoucherType) {
        image = response.brand?.logo ?? ""
        title = response.name ?? ""
        id = response.voucherID ?? ""
        itemId = response.voucherItemID ?? ""

        let dateString = response.expiredTime ?? ""
        let formattedTime = dateString.dateToString(fromFormat: DateFormat.server,
                                                     DateFormat.myVoucher)
        deadline = formattedTime.isEmpty ? "" : String(format: "voucher.deadline".localized, formattedTime)
        expiredDate = dateString.parseToDate(with: DateFormat.server)
        self.type = type
        isMobileCard = response.productModelCode == "PRODUCT_MODEL_MOBILE_CARD"
    }
}
