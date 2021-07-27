//
//  ChangePointPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol ChangePointPresenterDelegate: BaseProtocols {
    func onUpdateSelection()
}

class ChangePointPresenter {
    weak var delegate: ChangePointPresenterDelegate?

    var selectedMonthly = true
    var selectingChangeAll = true {
        didSet {
            if selectingChangeAll != oldValue {
                value = ""
                delegate?.onUpdateSelection()
            }
        }
    }
    var value = ""
}
