//
//  NewsHeaderCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/6/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class NewsHeaderCell: UICollectionViewCell {

  @IBOutlet weak var newsHeaderLabel: UILabel!
  @IBOutlet weak var viewAllButton: UIButton!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      newsHeaderLabel.text = "main.news".localized
      viewAllButton.setTitle("main.view_all".localized, for: .normal)
      viewAllButton.setTitleColor(UIColor(hexString: "#7493DB"), for: .normal)
    }
    @IBAction func viewAllButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NewsListViewController")
        controller.hidesBottomBarWhenPushed = true
       let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
       tabbarViewController?.navigationBar.isHidden = false
       tabbarViewController?.pushViewController(controller, animated: true)
    }
    
}
