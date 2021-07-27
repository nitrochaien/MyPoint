//
//  SuggestionHeaderCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class SuggestionHeaderCell: UICollectionViewCell {

  @IBOutlet weak var suggestionHeaderLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      suggestionHeaderLabel.text = "main.suggestion".localized
    }
    
    func setData(string: String) {
        suggestionHeaderLabel.text = string
    }

}
