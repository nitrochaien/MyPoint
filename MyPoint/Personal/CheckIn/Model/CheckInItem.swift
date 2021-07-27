//
//  CheckInItem.swift
//  MyPoint
//
//  Created by Nam Vu on 2/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class CheckInItem {
    enum SelectionType {
        case today
        case checkedIn
        case notCheckedIn
    }

    let title: String
    var type: SelectionType

    init(title: String, type: SelectionType) {
        self.title = title
        self.type = type
    }

    static var today: CheckInItem {
        return .init(title: "check-in.today".localized, type: .today)
    }

    static var checkedInToday: CheckInItem {
        return .init(title: "check-in.today".localized, type: .checkedIn)
    }
}
