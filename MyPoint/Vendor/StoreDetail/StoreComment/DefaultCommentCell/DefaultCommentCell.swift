//
//  DefaultCommentCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 4/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class DefaultCommentCell: UITableViewCell {

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var commentDateLabel: UILabel!
  @IBOutlet weak var commentHeaderLabel: UILabel!
  @IBOutlet weak var commentLabel: UILabel!
//  @IBOutlet weak var commentImageView: UIImageView!
  
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
  
    func setData(comment: StoreComment) {
      if let url = URL(string: comment.reviewer?.avatar ?? "") {
          self.avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
      } else {
          self.avatarImageView.image = UIImage(named: "alter")
      }
      
      userNameLabel.text = comment.reviewer?.fullName
      commentDateLabel.text = comment.createTime?.dateToString(fromFormat: DateFormat.server, DateFormat.myVoucher)
      commentHeaderLabel.text = Rating(rawValue: Int(comment.reviewRating ?? "0") ?? 0)?.string
      commentLabel.text = comment.reviewContent
//      commentImageView.isHidden = true
    }
}
