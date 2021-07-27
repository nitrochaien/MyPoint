//
//  InterestedItem.swift
//  MyPoint
//
//  Created by Nam Vu on 1/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class InterestedItem: Equatable {
    let title: String
    let code: String
    var isSelected: Bool
    let icon: String

    init(_ data: InterestedListItem) {
        title = data.categoryName ?? ""
        code = data.categoryCode ?? ""
        isSelected = data.subscribed ?? "" == "1" ? true : false
        icon = data.imageurl ?? ""
    }

    static func == (lhs: InterestedItem, rhs: InterestedItem) -> Bool {
        return rhs.code == lhs.code
    }
}
