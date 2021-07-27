//
//  NewMerchantProfileCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 3/23/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class NewMerchantProfileCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var merchantProfileImageView: UIImageView!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var accumulatedPercentHeaderLabel: UILabel!
    @IBOutlet weak var accumulatedPercentLabel: UILabel!
    @IBOutlet weak var merchantCategoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.addShadow(ofColor: .lightGray,
                                radius: 8,
                                offset: .zero,
                                opacity: 0.5)
        merchantNameLabel.font = UIFont(name: "iCielGraphik-Demibold", size: 12)
    }

    func setData(brand: Brand) {
        if let url = URL(string: brand.logo ?? "") {
            self.merchantProfileImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
        } else {
            self.merchantProfileImageView.image = UIImage(named: "alter")
        }

        merchantNameLabel.text = brand.brandName?.uppercased()

        //      if let url = URL(string: brand.category?.imageURL ?? "") {
        //        self.categoryLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
        //      } else {
        //       self.categoryLogoImageView.image = UIImage(named: "alter")
        //      }

        merchantCategoryLabel.text = brand.category?.categoryName
        accumulatedPercentHeaderLabel.text = String(format: "merchant.point_accumulation_rate".localized, "")
        accumulatedPercentLabel.text = (brand.displayPointAccumulationRate ?? "") + "%"
    }
}
