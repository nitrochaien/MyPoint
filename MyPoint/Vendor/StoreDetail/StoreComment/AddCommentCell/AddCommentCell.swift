//
//  AddCommentCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 4/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class AddCommentCell: UITableViewCell, AddCommentTextViewDidChangeProtocol {
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var commentContainerView: UIView!
  @IBOutlet weak var ratingView: CosmosView!
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var commentViewButton: UIButton!
  
  override func awakeFromNib() {
        super.awakeFromNib()
      selectionStyle = .none
      let storage = Storage.shared
      let userData = storage.loginData
      if let localImage = storage.localUserProfilePic {
        avatarImageView.image = localImage
      } else {
        avatarImageView.image = userData?.workerSite?.image
      }
      ratingView.settings.fillMode = .full
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func addCommentTextViewDidChange(comment: String) {
      commentLabel.text = comment
    }
    
    func didChangeRating(rate: Double) {
      ratingView.rating = rate
    }
    
}
