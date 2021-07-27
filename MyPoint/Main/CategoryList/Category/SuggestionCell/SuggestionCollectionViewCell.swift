//
//  SuggestionCollectionViewCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class SuggestionCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var suggestionImageView: UIImageView!
  @IBOutlet weak var suggetionTitleLabel: UILabel!
  @IBOutlet weak var suggetionPointLabel: UILabel!
  @IBOutlet weak var suggestionBrandLogoImageView: UIImageView!
  @IBOutlet weak var suggestionBrandNameLabel: UILabel!
  @IBOutlet weak var outOfStockView: UIView!
  @IBOutlet weak var outOfStockLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        outOfStockLabel.text = "voucher.out_of_stock".localized
        // Initialization code
    }
  
  func setData(voucher: HotVoucher) {
    if let url = URL(string: voucher.images?.first?.imageURL ?? "") {
      suggestionImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
    } else {
      suggestionImageView.image = UIImage(named: "alter")
    }
    
    suggetionTitleLabel.text = voucher.name ?? ""
    let point = voucher.prices?.first?.payPoint ?? "0"
    suggetionPointLabel.text = Double(point)?.formattedWithSeparator
    
    if let url = URL(string: voucher.brand?.logo ?? "") {
      suggestionBrandLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
    } else {
      suggestionBrandLogoImageView.image = UIImage(named: "alter")
    }
    
    suggestionBrandNameLabel.text = voucher.brand?.brandName ?? ""

    let isOnStock = voucher.amount != 0
    outOfStockView.isHidden = isOnStock
    outOfStockLabel.isHidden = isOnStock
  }
}
