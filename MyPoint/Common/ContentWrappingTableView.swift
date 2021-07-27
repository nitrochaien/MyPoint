//
//  ContentWrappingTableView.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 4/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit

class ContentWrappingTableView: UITableView {

  override var intrinsicContentSize: CGSize {
    return self.contentSize
  }

  override var contentSize: CGSize {
    didSet {
        self.invalidateIntrinsicContentSize()
    }
  }
}
