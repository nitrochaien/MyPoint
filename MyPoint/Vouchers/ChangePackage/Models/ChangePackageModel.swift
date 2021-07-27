//
//  ChangePackageModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class ChangePackageModel: Equatable {
    let id: Int
    let icon: String
    let price: String
    let priceValue: Int
    let header: String
    let content: String
    var isSelected: Bool

    init(id: Int, isSelected: Bool = false) {
        self.id = id
        icon = ""
        price = String(format: "voucher.price".localized, Double(2000).formattedWithSeparator)
        priceValue = 2000
        header = "Gói cước Thành viên Thân thiết"
        content = "Chỉ với 2000 điểm bạn sẽ nhận được 100 phút thoại."
        self.isSelected = isSelected
    }

    static func == (lhs: ChangePackageModel, rhs: ChangePackageModel) -> Bool {
        return rhs.id == lhs.id
    }
}
