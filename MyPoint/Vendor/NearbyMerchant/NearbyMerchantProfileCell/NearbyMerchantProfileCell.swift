//
//  NearbyMerchantProfileCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class NearbyMerchantProfileCell: UITableViewCell {

    @IBOutlet weak var nearbyMerchantImageView: UIImageView!
    @IBOutlet weak var nearbyMerchantNameLabel: UILabel!
    @IBOutlet weak var nearbyMerchantAddressLabel: UILabel!
    @IBOutlet weak var nearbyMerchantDistanceLabel: UILabel!
    @IBOutlet weak var distanceHeaderImage: UIImageView!
    @IBOutlet weak var containterView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containterView.addShadow(ofColor: .lightGray,
                                 radius: 8,
                                 offset: .zero,
                                 opacity: 0.5)
    }

    func setData(store: NearbyBrandStore, didGetLocation: Bool) {
        nearbyMerchantNameLabel.text = store.name
        nearbyMerchantAddressLabel.text = store.address
        if didGetLocation {
          nearbyMerchantDistanceLabel.text = store.displayDistance
          nearbyMerchantDistanceLabel.isHidden = false
          distanceHeaderImage.isHidden = false
        } else {
          nearbyMerchantDistanceLabel.isHidden = true
          distanceHeaderImage.isHidden = true
        }
        nearbyMerchantImageView.setImage(withURL: store.logo)
    }
}
