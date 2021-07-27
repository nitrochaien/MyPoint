//
//  PersonalMenu.swift
//  MyPoint
//
//  Created by Nam Vu on 12/29/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import Foundation

struct PersonalItem: Decodable {
    let icon: String
    let title: String
    let section: Int
    let titleColor: String
    let id: Int
    let accessory: String
}

enum PersonalMenu: Int {
    case pointHunting = 0, checkIn, promotion, inviteFriends, enterCode, gift,
    exchangePoint, history, favorite, info, support, rating, settings, signOut
}
