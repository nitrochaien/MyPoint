//
//  ChangePasswordRequestModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

struct ForgotPasswordRequestModel {
    let loginName: String
    let password: String

    init(loginName: String, password: String) {
        self.loginName = loginName
        self.password = password
    }

    var toParams: [String: Any] {
        return [
            "login_name": loginName,
            "password": password.sha256(),
            "lang": Localize.shared.currentLanguage
        ]
    }
}
