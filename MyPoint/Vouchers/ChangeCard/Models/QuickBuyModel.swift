//
//  QuickBuyModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class QuickBuyModel: Equatable {
    let icon: String
    let date: String
    let name: String
    let value: String
    let id: Int

    init(id: Int) {
        icon = "https://salt.tikicdn.com/assets/img/vas/mobifone.png"
        date = "28/10/2019"
        name = "Mobifone"
        value = String(format: "%d%@", 10000, "voucher.vnd".localized)
        self.id = id
    }

    static func == (lhs: QuickBuyModel, rhs: QuickBuyModel) -> Bool {
        return rhs.id == lhs.id
    }
}
