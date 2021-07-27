//
//  ChooseBankPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/8/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class ChooseBankPresenter {
    class BankModel {
        let id: String
        let icon: String
        let name: String
        var isSelected: Bool

        init(id: String, icon: String, name: String) {
            self.id = id
            self.icon = icon
            self.name = name
            self.isSelected = false
        }
    }

    var banks = [BankModel]()
}
