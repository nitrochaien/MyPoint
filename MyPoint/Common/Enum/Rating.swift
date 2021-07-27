//
//  Rating.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 6/1/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

enum Rating: Int, CaseIterable {
  case worst = 1
  case bad
  case normal
  case good
  case excellent
  
  var string: String {
        switch self {
          
        case .worst:          return "merchant.worst".localized
    
        case .bad:            return "merchant.bad".localized
       
        case .normal:         return "merchant.normal".localized
    
        case .good:           return "merchant.good".localized
          
        case .excellent:      return "merchant.excellent".localized
        }
  }
}
