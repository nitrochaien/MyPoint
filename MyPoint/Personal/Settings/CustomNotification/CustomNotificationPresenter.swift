//
//  CustomNotificationPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class CustomNotificationPresenter {
    class Item: Decodable {
        let name: String
        let id: Int
        var selected: Bool
    }

    weak var delegate: BaseProtocols?

    var items = [Item]()

    func generateData() {
        items = load("custom_noti.json")
        delegate?.requestSuccess()
    }
}
