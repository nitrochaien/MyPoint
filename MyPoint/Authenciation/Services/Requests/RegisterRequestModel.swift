//
//  RegisterRequestModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

struct RegisterRequestModel {
    let accountName: String
    let fullname: String
    let nickname: String
    let password: String

    init(accountName: String, nickname: String = "", password: String) {
        self.accountName = accountName
        self.fullname = nickname
        self.nickname = nickname
        self.password = password
    }

    var toParams: [String: Any] {
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let hardware_info = "hardware_type: \(isPhone ? "Mobile" : "Tablet"), hardware_model: \(UIDevice.current.type.rawValue)" +
        ", operating_system: iOS, Version: \(String(format: "Version %@, build %@", version, build))" +
        ", user_device_name: \(UIDevice.current.name)"
        return [
            "account_name": accountName,
            "fullname": fullname,
            "nickname": nickname,
            "password": password.sha256(),
            "account_login": 1,
            "device_key": Storage.shared.deviceToken ?? "",
            "lang": Localize.shared.currentLanguage,
            "fcm_token": Storage.shared.firebaseToken ?? "",
            "hardware_info": hardware_info
        ]
    }
}
