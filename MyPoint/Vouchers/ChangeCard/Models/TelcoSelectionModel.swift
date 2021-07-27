//
//  TelcoSelectionModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class TelcoSelectionModel: Equatable {
    let image: String
    var isSelected: Bool
    let id: String
    let isEnable: Bool
    let code: String
    var values: [TopUpValueModel]

    var selectedValue: TopUpValueModel? {
        return values.first { model -> Bool in
            return model.isSelected
        }
    }

    init(id: String, selected: Bool, isEnable: Bool = false, image: String) {
        self.image = image
        self.id = id
        self.isSelected = selected
        self.isEnable = isEnable
        code = ""
        values = []
    }

    init(data: TelcoProduct) {
        image = data.brandLogo ?? ""
        id = data.brandid ?? ""
        isSelected = false
        isEnable = true
        code = data.brandCode ?? ""
        if data.prices?.isEmpty == false {
            values = [.init(data: data)]
        } else {
            values = []
        }
    }

    func deselectAllPrices() {
        values.forEach { model in
            model.isSelected = false
        }
    }

    static func == (lhs: TelcoSelectionModel, rhs: TelcoSelectionModel) -> Bool {
        return rhs.id == lhs.id
    }
}
