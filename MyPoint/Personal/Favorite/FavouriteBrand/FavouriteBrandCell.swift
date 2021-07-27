//
//  FavouriteBrandCell.swift
//  MyPoint
//
//  Created by Hieu on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import SwipeCellKit

class FavouriteBrandCell: SwipeTableViewCell {
    
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func setData(brand: Brand) {
      brandName.text = brand.brandName ?? ""
      
      if let url = URL(string: brand.logo ?? "") {
        self.brandImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
      } else {
       self.brandImageView.image = UIImage(named: "alter")
      }
    }
    
}
