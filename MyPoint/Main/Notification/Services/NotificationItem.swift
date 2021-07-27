//
//  NotificationItem.swift
//  MyPoint
//
//  Created by Nam Vu on 2/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class NotificationItem {
    let icon: String
    let name: String
    let description: String
    var hasSeen: Bool
    let id: String
    let clickAction: String
    let clickActionParams: String

    init(with data: NotificationListItem) {
        icon = data.workingSite?.avatar ?? ""
        name = data.title ?? ""
        description = data.body ?? ""
        hasSeen = !(data.seenAt ?? "").isEmpty
        id = data.notificationid ?? ""
        clickAction = (data.clickAction ?? "").trimmed
        clickActionParams = (data.clickActionParam ?? "").trimmed
    }
}
