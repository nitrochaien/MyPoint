//
//  CardHistoryModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

struct CardHistoryModel {
    let icon: String
    let value: String
    let telco: String
    let phone: String
    let serial: String
    let date: String
    let id: Int

    init() {
        icon = "https://salt.tikicdn.com/assets/img/vas/mobifone.png"
        value = String(format: "voucher.price".localized, 2000)
        telco = "Mobifone"
        phone = "19001745"
        serial = String(format: "voucher.serial".localized, "59000005828657")
        date = "25/10/2019 18:21"
        id = 0
    }
}
