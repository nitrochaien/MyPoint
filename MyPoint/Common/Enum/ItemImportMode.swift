//
//  ItemImportMode.swift
//  MyPoint
//
//  Created by Dieu on 19/03/2021.
//  Copyright © 2021 NamDV. All rights reserved.
//

import Foundation
enum ItemImportMode: Int, CaseIterable {
  case ITEM_IMPORTED_IN_ADVANCE = 1
  case ITEM_IMPORTED_AT_TIME_OF_REDEMPTION
  
  var string: String {
        switch self {
          
        case .ITEM_IMPORTED_IN_ADVANCE:
            return "ITEM_IMPORTED_IN_ADVANCE"
    
        case .ITEM_IMPORTED_AT_TIME_OF_REDEMPTION:
            return "ITEM_IMPORTED_AT_TIME_OF_REDEMPTION"
        }
  }
}
