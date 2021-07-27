//
//  GivePointModel.swift
//  MyPoint
//
//  Created by Nam Vu on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class GivePointModel {
    var name: String = ""
    var phone: String = ""
    var point: String = ""
    var content: String = ""
    var isNotInContact: Bool = false

    var toParams: [String: Any] {
        return [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "pool_code": "MPS",
            "pool_amount": point.replacingOccurrences(of: ".", with: ""),
            "note": content,
            "receiver_phone_number": phone.convertToLeadingZeroPhoneNumber(),
            "lang": Localize.shared.currentLanguage,
            "get_customer_balance": "1"
        ]
    }

    func reset() {
        name = ""
        phone = ""
        point = ""
        content = ""
    }
}
