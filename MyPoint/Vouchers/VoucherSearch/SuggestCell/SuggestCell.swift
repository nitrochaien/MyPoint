//
//  SuggestCell.swift
//  MyPoint
//
//  Created by Hieu on 2/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import SwipeCellKit

class SuggestCell: SwipeTableViewCell {

    @IBOutlet weak var voucherImageView: UIImageView!
    @IBOutlet weak var voucherNameLabel: UILabel!
    @IBOutlet weak var voucherPriceLabel: UILabel!
    @IBOutlet weak var myPointImageView: UIImageView!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var outOfStockView: UIView!
    @IBOutlet weak var outOfStockLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(voucher: HotVoucher?) {
        voucherNameLabel.text = voucher?.name ?? ""
        let priceValue = Double(voucher?.prices?.first?.payPoint ?? "") ?? 0
        voucherPriceLabel.text = priceValue.formattedWithSeparator
        brandNameLabel.text = voucher?.brand?.brandName
        voucherImageView.setImage(withURL: voucher?.images?.first?.imageURL)
        brandImageView.setImage(withURL: voucher?.brand?.logo)

        let distanceValue = Double(voucher?.distance ?? "") ?? 0
        distanceView.isHidden = distanceValue == 0
        if distanceValue != 0 {
            distanceLabel.text = String(format: "%.1f km", distanceValue)
        } else {
            distanceLabel.text = ""
        }
      
        if voucher?.amount == 0 {
          outOfStockView.isHidden = false
          outOfStockLabel.isHidden = false
        }
    }
}
