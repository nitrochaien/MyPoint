//
//  VerifyOTPRequestModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

struct VerifyOTPRequestModel {
    let ownerId: String
    let otp: String
    let timeToDoNextEvent: Int
    let nextEventName: NextEventName

    init(ownerId: String,
         otp: String,
         timeToDoNextEvent: Int,
         nextEventName: NextEventName) {
        self.ownerId = ownerId
        self.otp = otp
        self.timeToDoNextEvent = timeToDoNextEvent
        self.nextEventName = nextEventName
    }

    var toParams: [String: Any] {
        return [
            "owner_id": ownerId,
            "otp": otp,
            "ttdne": String(timeToDoNextEvent),
            "next_event_name": nextEventName.rawValue,
            "lang": Localize.shared.currentLanguage
        ]
    }
}

enum NextEventName: String {
    case signUp = "SIGN_UP"
    case resetPassword = "RESET_PASSWORD"
}
