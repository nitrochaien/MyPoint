//
//  HotVoucherRequestModel.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

struct ListHotVoucherRequestModel {
  
  var toParams: [String: Any] {
    return [
        "lang": Localize.shared.currentLanguage
    ]
  }
}
