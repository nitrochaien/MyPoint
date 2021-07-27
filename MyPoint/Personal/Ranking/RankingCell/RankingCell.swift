//
//  RankingCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/12/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankPointLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        rankPointLabel.textColor = UIColor(hexString: "36399C")
    }

    func setData(_ data: RankingPresenter.Model) {
        rankImageView.isHidden = true
        rankLabel.isHidden = true
        switch data.rank {
        case 1:
            rankImageView.isHidden = false
            rankImageView.image = UIImage(named: "Group 237")
        case 2:
            rankImageView.isHidden = false
            rankImageView.image = UIImage(named: "Group 241")
        case 3:
            rankImageView.isHidden = false
            rankImageView.image = UIImage(named: "Group 242")
        default:
            rankLabel.isHidden = false
            rankLabel.text = String(data.rank)
        }
        avatarImageView.setImage(withURL: data.image)
        nameLabel.text = data.name
        rankPointLabel.text = data.value + " Điểm"
    }
    
}
