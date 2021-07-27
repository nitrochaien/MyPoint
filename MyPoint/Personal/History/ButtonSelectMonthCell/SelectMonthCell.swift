//
//  SelectMonthCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class SelectMonthCell: UITableViewCell {

    @IBOutlet weak var selectMonthButton: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func selectMonthButtonTapped(_ sender: Any) {
    }
  
}
