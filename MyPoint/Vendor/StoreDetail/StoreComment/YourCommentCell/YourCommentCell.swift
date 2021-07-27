//
//  YourCommentCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 4/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class YourCommentCell: UITableViewCell {

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var commentDateLabel: UILabel!
  @IBOutlet weak var commentHeaderLabel: UILabel!
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    selectionStyle = .none
//        containerView.layer.cornerRadius = 8
//        containerView.layer.borderWidth = 0
//        containerView.addShadow(ofColor: .lightGray,
//                                   radius: 8,
//                                   offset: .zero,
//                                   opacity: 0.5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
