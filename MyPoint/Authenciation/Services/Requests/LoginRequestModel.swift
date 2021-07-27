//
//  LoginRequestModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

struct LoginRequestModel {
    let username: String
    let password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    var toParams: [String: Any] {
        return [
            "username": username,
            "password": password.sha256(),
            "device_key": Storage.shared.deviceToken ?? "",
            "lang": Localize.shared.currentLanguage
        ]
    }
}
