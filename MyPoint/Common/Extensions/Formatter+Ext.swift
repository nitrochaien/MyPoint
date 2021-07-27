//
//  Formatter+Ext.swift
//  MyPoint
//
//  Created by Nam Vu on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
  
    static let withDoubleSeparator: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.groupingSeparator = "."
            formatter.numberStyle = .none
            return formatter
    }()
}

extension Double {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
  
    var formattedWithDoubleSeparator: String {
        return Formatter.withDoubleSeparator.string(for: self) ?? ""
    }
}
