//
//  SettingsItem.swift
//  MyPoint
//
//  Created by Nam Vu on 1/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

struct SettingsItem: Decodable {
    let icon: String
    let title: String
    let titleColor: String
    let id: Int
    let toggle: Bool
}

enum SettingMenu: Int {
//    case changeTheme = 0, language, notificationSettings, interestedCategories,
//    changePin, unlockByBiometry, requestPinCodeInTransaction
    
    case changeTheme = 0, notificationSettings, interestedCategories,
    changePin, unlockByBiometry, requestPinCodeInTransaction
}
