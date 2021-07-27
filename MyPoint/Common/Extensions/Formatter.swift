//
//  Formatter.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// extension Formatter {
//    static let withSeparator: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.groupingSeparator = "."
//        formatter.numberStyle = .decimal
//        return formatter
//    }()
// }

extension Numeric {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
