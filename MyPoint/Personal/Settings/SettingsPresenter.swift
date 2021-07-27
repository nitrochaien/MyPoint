//
//  SettingsPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class SettingsPresenter {
    var items = [SettingsItem]()

    weak var delegate: BaseProtocols?

    func generateData() {
        items = load("setting_list.json")
        delegate?.requestSuccess()
    }
}
