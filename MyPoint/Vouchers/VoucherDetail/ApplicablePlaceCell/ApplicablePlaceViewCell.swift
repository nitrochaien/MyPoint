//
//  ApplicablePlaceViewCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class ApplicablePlaceViewCell: UITableViewCell {

  @IBOutlet weak var placeLogoImageView: UIImageView!
  @IBOutlet weak var placeTitleLabel: UILabel!
  @IBOutlet weak var placeAddressLabel: UILabel!
  @IBOutlet weak var placeDistanceLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func setData(place: StoreList, brand: Brand) {
      placeTitleLabel.text = place.name
      placeDistanceLabel.text = place.displayDistance
      placeAddressLabel.text = place.address
      if let imageUrl = brand.logo, let url = URL(string: imageUrl) {
        placeLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
        placeLogoImageView.makeRoundedImage()
      } else {
        placeLogoImageView.image = UIImage(named: "alter")
      }
    }
    
    override func prepareForReuse() {
        placeTitleLabel.text = nil
        placeDistanceLabel.text = nil
        placeAddressLabel.text = nil
    }
}
