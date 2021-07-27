//
//  BrandItemCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/6/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class BrandItemCell: UICollectionViewCell {

  @IBOutlet weak var brandBackGroundImageView: UIImageView!
  @IBOutlet weak var brandImageView: UIImageView!
  @IBOutlet weak var brandNameLabel: UILabel!
  @IBOutlet weak var hotVoucherContentLabel: UILabel!
  @IBOutlet weak var categoryTitleLabel: UILabel!
  @IBOutlet weak var categoryImageView: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
