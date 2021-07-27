//
//  CommonPresenterProtocols.swift
//  MyPoint
//
//  Created by Nam Vu on 12/28/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit
import SwifterSwift

protocol BaseProtocols: NSObjectProtocol {
    func showError(message: String)
    func requestSuccess()
}

extension BaseProtocols where Self: UIViewController {
    func showError(message: String) {
        showCustomAlert(withTitle: "api.error".localized, andContent: message)
    }
}
