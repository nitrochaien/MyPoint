//
//  SupportItem.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

struct SupportItem: Decodable {
    let icon: String
    let title: String
    let value: String
    let id: Int

    init(type: SupportMenu) {
        switch type {
//        case .facebook:
//            icon = "ic_facebook"
//            title = Defines.facebook
//            value = "https://\(Defines.facebook)"
        case .mail:
            icon = "ic_mail"
            title = Defines.email
            value = Defines.email
        case .phone:
            icon = "ic_phone"
            title = Defines.hotline
            value = Defines.hotline
        case .question:
            icon = "ic_question"
            title = "support.question".localized
            value = ""
        case .policy:
            icon = "ic_policy"
            title = "support.policy".localized
            value = ""
        }
        id = type.rawValue
    }
}

enum SupportMenu: Int, CaseIterable {
//    case facebook = 0, mail, phone, question, policy
    case mail = 0, phone, question, policy
}
