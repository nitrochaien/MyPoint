//
//  UITableView+Ext.swift
//  MyPoint
//
//  Created by Nam Vu on 3/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

extension UITableView {
    func registerEmptyCell() {
        register(UINib(nibName: "NoDataVoucherTableViewCell", bundle: nil),
                 forCellReuseIdentifier: "NoDataVoucherTableViewCell")
    }
}
