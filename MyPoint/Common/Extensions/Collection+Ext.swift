//
//  Collection+Ext.swift
//  MyPoint
//
//  Created by Nam Vu on 2/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
