//
//  MerchantProfileCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class MerchantProfileCell: UITableViewCell {

  @IBOutlet weak var merchantProfileImageView: UIImageView!
  @IBOutlet weak var merchantNameLabel: UILabel!
  @IBOutlet weak var categoryLogoImageView: UIImageView!
  @IBOutlet weak var categoryNameLabel: UILabel!
  @IBOutlet weak var topUpPercentageLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func setData(brand: Brand) {
      if let url = URL(string: brand.logo ?? "") {
        self.merchantProfileImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
      } else {
       self.merchantProfileImageView.image = UIImage(named: "alter")
      }
      
      merchantNameLabel.text = brand.brandName
      
      if let url = URL(string: brand.category?.imageURL ?? "") {
        self.categoryLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
      } else {
       self.categoryLogoImageView.image = UIImage(named: "alter")
      }
      
      categoryNameLabel.text = brand.category?.categoryName
      
      topUpPercentageLabel.text = String(format: "merchant.point_accumulation_rate".localized, (brand.displayPointAccumulationRate ?? "")) +
       "%"
    }
}
