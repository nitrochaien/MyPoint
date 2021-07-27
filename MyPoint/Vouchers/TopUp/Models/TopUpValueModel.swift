//
//  TopUpValueModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/18/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class TopUpValueModel: Equatable {
    let value: String
    let price: String
    var isSelected: Bool
    let id: String
    let isTopup: Bool

    let icon: String
    let header: String
    let content: String
    let priceValue: Double

    init(id: String, isSelection: Bool = false, price: Double, isTopup: Bool) {
        self.value = String(format: "%@%@", price.formattedWithSeparator, "voucher.vnd".localized)
        self.price = String(format: "voucher.price".localized, 100.formattedWithSeparator)
        self.isSelected = isSelection
        self.id = id
        self.isTopup = isTopup
        icon = ""
        header = ""
        content = ""
        priceValue = 0
    }

    init(data: TelcoProduct) {
        priceValue = Double(data.prices?.first?.payPoint ?? "") ?? 0
        price = String(format: "voucher.price".localized, priceValue.formattedWithSeparator)

        let priceValue = Double(data.prices?.first?.originalPrice ?? "") ?? 0
        value = String(format: "%@%@", priceValue.formattedWithSeparator, "voucher.vnd".localized)

        icon = data.images?.first?.imageurl ?? ""
        header = data.name ?? ""
        content = data.productDescription ?? ""

        isSelected = false
        id = data.id ?? ""
        isTopup = false
    }

    init() {
        value = ""
        price = ""
        isSelected = false
        id = ""
        isTopup = false
        icon = ""
        header = ""
        content = ""
        priceValue = 0
    }

    static func == (lhs: TopUpValueModel, rhs: TopUpValueModel) -> Bool {
        return rhs.id == lhs.id
    }
}
