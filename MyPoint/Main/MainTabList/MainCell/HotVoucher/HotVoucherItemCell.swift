//
//  HotVoucherItemCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/6/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class HotVoucherItemCell: UICollectionViewCell {

  @IBOutlet weak var hotVoucherImageView: UIImageView!
  @IBOutlet weak var hotVoucherTitleLabel: UILabel!
  @IBOutlet weak var hotVoucherBrandImageView: UIImageView!
  @IBOutlet weak var hotVoucherBrandNameLabel: UILabel!
  @IBOutlet weak var hotVoucherPriceLabel: UILabel!
  @IBOutlet weak var pointIconImageView: UIImageView!
  @IBOutlet weak var hotVoucherSaleBackGround: GradientView!
  @IBOutlet weak var hotVoucherSaleLabel: UILabel!
  @IBOutlet weak var outOfStockView: UIView!
  @IBOutlet weak var outOfStockLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        hotVoucherSaleBackGround.roundCorners([.bottomLeft, .topRight, .topLeft], radius: 8)
        hotVoucherSaleBackGround.startColor = UIColor(hexString: "#F15757")!
        hotVoucherSaleBackGround.endColor = UIColor(hexString: "#C20018")!
        outOfStockView.roundCorners([.bottomLeft, .topRight, .bottomRight], radius: 8)
        outOfStockLabel.text = "voucher.out_of_stock".localized
    }

}
