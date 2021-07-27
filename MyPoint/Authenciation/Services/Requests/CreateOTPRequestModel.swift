//
//  CreateOTPRequestModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

struct CreateOTPRequestModel {
    let ownerId: String
    let timeToLive: Int

    init(ownerId: String, timeToLive: Int) {
        self.ownerId = ownerId
        self.timeToLive = timeToLive
    }

    var toParams: [String: Any] {
        return [
            "owner_id": ownerId,
            "ttl": String(timeToLive),
            "resend_after_second": Defines.resendOTPCountdown,
            "lang": Localize.shared.currentLanguage
        ]
    }
}
