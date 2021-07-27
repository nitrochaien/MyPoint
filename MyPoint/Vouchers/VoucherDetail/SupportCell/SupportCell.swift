//
//  SupportCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class SupportCell: UITableViewCell {
  
    @IBOutlet weak var supportImageView: UIImageView!
    @IBOutlet weak var supportTextLabel: UILabel!
    @IBOutlet weak var supportMoreButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func hideCell() {
      supportTextLabel.isHidden = true
      supportImageView.isHidden = true
      supportMoreButton.isHidden = true
      separatorView.isHidden = true
    }
    
    @IBAction func supportMoreButtonTapped(_ sender: Any) {
      
    }
}
