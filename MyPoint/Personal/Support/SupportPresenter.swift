//
//  SupportPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class SupportPresenter {
    var items = [SupportItem]()

    weak var delegate: BaseProtocols?

    func generateData() {
        SupportMenu.allCases.forEach { type in
            items.append(.init(type: type))
        }
    }
}
