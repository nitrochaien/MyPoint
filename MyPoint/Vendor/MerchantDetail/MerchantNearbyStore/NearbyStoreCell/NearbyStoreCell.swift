//
//  NearbyStoreCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class NearbyStoreCell: UITableViewCell {

  @IBOutlet weak var merchantImageView: UIImageView!
  @IBOutlet weak var merchantNameLabel: UILabel!
  @IBOutlet weak var merchantAddressLabel: UILabel!
  @IBOutlet weak var merchantPhoneLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func setData(store: NearbyBrandStore) {
        if let url = URL(string: store.brand?.logo ?? "") {
        self.merchantImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
      } else {
        self.merchantImageView.image = UIImage(named: "alter")
      }
      
      merchantNameLabel.text = store.name ?? ""
      merchantAddressLabel.text = store.address ?? ""
      merchantPhoneLabel.text = store.phone ?? ""
    }
    
}
